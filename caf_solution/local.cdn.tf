  locals {
    cdn =  merge(
      var.cdn,{
      cdn_frontdoor_profiles = try(var.cdn.cdn_frontdoor_profiles, {})
    }
    )
  }
