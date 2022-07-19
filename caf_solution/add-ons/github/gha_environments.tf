data "github_user" "users" {
  for_each = local.users

  username = each.key
}

data "github_team" "teams" {
  for_each = local.teams

  slug = each.key
}

resource "github_repository_environment" "env" {
  for_each = local.environments

  repository   = each.value.repo
  environment  = each.value.env
  reviewers {
    users = [for i in try(each.value.reviewers.users, []): data.github_user.users[i].id]
    teams = [for i in try(each.value.reviewers.teams, []): data.github_team.teams[i].id]
  }
}

locals {
  teams = toset(
    flatten([
      for repo, repo_settings in var.gh_environments : [
        for env, env_settings in repo_settings : [
          try(env_settings.reviewers.teams, [])
        ]
      ]
    ])
  )

  users = toset(
    flatten([
      for repo, repo_settings in var.gh_environments : [
        for env, env_settings in repo_settings : [
          try(env_settings.reviewers.users, [])
        ]
      ]
    ])
  )

  environments = {
    for item in flatten([
      for repo, repo_settings in var.gh_environments: [
        for env, env_settings in repo_settings: {
          value = {
            env = env
            reviewers = env_settings.reviewers
            repo = repo
          }
        }
      ]
    ]) : format("%s-%s", item.value.repo, item.value.env) => item.value
  }
}
