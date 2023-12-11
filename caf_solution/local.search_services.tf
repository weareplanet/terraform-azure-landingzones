locals {
  search_services = merge(
    var.search_services,
    {
      search_services = var.search_services
    }
  )
}
