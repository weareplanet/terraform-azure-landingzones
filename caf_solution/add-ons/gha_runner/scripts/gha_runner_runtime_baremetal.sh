#!/usr/bin/env bash

set -euxo pipefail

REPO=${1} # if non empty, add runner at repo scope, else add to org
GH_ORG=${2}
TOKEN=${3}
PREFIX=${4}
ADMIN_USER=${5}
NUM_RUNNERS=${6}
LABELS=${7}
RUNNER_GROUP=${8}

LATEST_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | grep -oP '"tag_name": "v\K(.*)(?=")')
RUNNER_URL="https://github.com/actions/runner/releases/download/v${LATEST_VERSION}/actions-runner-linux-x64-${LATEST_VERSION}.tar.gz"
if [[ ${REPO} == "" ]]; then
  RUNNER_TOKEN_URL="https://api.github.com/orgs/${GH_ORG}/actions/runners/registration-token"
  REGISTRATION_URL="https://github.com/${GH_ORG}"
else
  RUNNER_TOKEN_URL="https://api.github.com/repos/${GH_ORG}/${REPO}/actions/runners/registration-token"
  REGISTRATION_URL="https://github.com/${GH_ORG}/${REPO}"
fi

export DEBIAN_FRONTEND=noninteractive
echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

echo "Installing dependencies"
sleep 10
apt-get update
apt-get install -y --no-install-recommends \
  ca-certificates \
  gnupg \
  lsb-release \
  jq

mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" |tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "Installing docker-ce"
apt-get update && apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Installing az cli"
curl -sL https://aka.ms/InstallAzureCLIDeb |bash

echo "Setting up docker"
usermod -aG docker ${ADMIN_USER}
systemctl daemon-reload
systemctl enable docker --now
docker --version

echo "Downloading runner package"
curl -sSL ${RUNNER_URL} -o /home/${ADMIN_USER}/$(basename ${RUNNER_URL})

for i in $(seq 1 ${NUM_RUNNERS}); do
  runner_name=${PREFIX}-${i}
  echo "Install ${runner_name}"

  mkdir /home/${ADMIN_USER}/${runner_name}
  pushd /home/${ADMIN_USER}/${runner_name}
  tar zxf ../$(basename ${RUNNER_URL})
  chown -R ${ADMIN_USER}: .

  echo "Fetching runner registration token from Github"
  RUNNER_TOKEN=$(curl -sS -X POST --url ${RUNNER_TOKEN_URL} -H "Authorization: Bearer ${TOKEN}" \
    -H 'Content-Type: application/json' | jq -r .token)

  sudo -u ${ADMIN_USER} ./config.sh --unattended --url ${REGISTRATION_URL} --token ${RUNNER_TOKEN} \
    --replace --name ${runner_name} --labels ${LABELS} --runnergroup ${RUNNER_GROUP}
  ./svc.sh install ${ADMIN_USER}
  ./svc.sh start

  popd
done
