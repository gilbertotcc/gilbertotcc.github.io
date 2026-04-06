terraform {
  backend "gcs" {
    bucket = "gilbertotaccaricom-tfstate"
    prefix = "live/porkbun"
  }
}

locals {
  # Following values are provided by GitHub during the domain verification
  # process.
  # See: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/verifying-your-custom-domain-for-github-pages
  #
  # IMPORTANT: Do not change these values to keep the domain verified.
  github_pages_challenge = {
    subdomain = "_github-pages-challenge-gilbertotcc"
    content   = "ac98ea27998108f82ab45d9de5bdf9"
  }

  # IP addresses provided by GitHub to point the A and AAAA records to.
  # See: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#dns-records-for-your-custom-domain
  a_records = [
    "185.199.108.153",
    "185.199.109.153",
    "185.199.110.153",
    "185.199.111.153"
  ]
  aaaa_records = [
    "2606:50c0:8000::153",
    "2606:50c0:8001::153",
    "2606:50c0:8002::153",
    "2606:50c0:8003::153"
  ]
}

# IMPORTANT: Do not remove the TXT record below to keep the domain verified by
# GitHub Pages.
resource "porkbun_dns_record" "gilbertotaccaricom_gh_domain_verification" {
  domain    = "gilbertotaccari.com"
  type      = "TXT"
  subdomain = local.github_pages_challenge.subdomain
  content   = local.github_pages_challenge.content
}

resource "porkbun_dns_record" "gh_a_record" {
  for_each = toset(local.a_records)
  domain   = "gilbertotaccari.com"
  type     = "A"
  content  = each.value
}

resource "porkbun_dns_record" "gh_aaaa_record" {
  for_each = toset(local.aaaa_records)
  domain   = "gilbertotaccari.com"
  type     = "AAAA"
  content  = each.value
}

# CNAME record required to enable HTTPS.
# See: https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site#dns-records-for-your-custom-domain
resource "porkbun_dns_record" "gilbertotaccaricom_cname" {
  domain    = "gilbertotaccari.com"
  type      = "CNAME"
  subdomain = "www"
  content   = "gilbertotcc.github.io"
}
