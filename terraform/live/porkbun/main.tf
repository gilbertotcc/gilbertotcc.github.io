terraform {
  backend "gcs" {
    bucket = "gilbertotaccaricom-tfstate"
    prefix = "live/porkbun"
  }
}

resource "porkbun_dns_record" "gilbertotaccaricom_gh_domain_verification" {
  domain    = "gilbertotaccari.com"
  type      = "TXT"
  subdomain = "_github-pages-challenge-gilbertotcc"
  content   = "ac98ea27998108f82ab45d9de5bdf9"
}

resource "porkbun_dns_record" "gh_a_record" {
  for_each = toset([
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153"
  ])
  domain  = "gilbertotaccari.com"
  type    = "A"
  content = each.value
}

resource "porkbun_dns_record" "gh_aaaa_record" {
  for_each = toset([
    "2606:50c0:8000::153",
    "2606:50c0:8001::153",
    "2606:50c0:8002::153",
    "2606:50c0:8003::153"
  ])
  domain  = "gilbertotaccari.com"
  type    = "AAAA"
  content = each.value
}

resource "porkbun_dns_record" "gilbertotaccaricom_cname" {
  domain    = "gilbertotaccari.com"
  type      = "CNAME"
  subdomain = "www"
  content   = "gilbertotcc.github.io"
}
