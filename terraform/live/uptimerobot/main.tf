terraform {
  backend "gcs" {
    bucket = "gilbertotaccaricom-tfstate"
    prefix = "live/uptimerobot"
  }
}

provider "uptimerobot" {}

resource "uptimerobot_monitor" "website" {
  name     = "gilbertotaccari.com"
  type     = "HTTP"
  url      = "https://gilbertotaccari.com"
  interval = 300
}

resource "uptimerobot_psp" "webisite" {
  name = "gilbertotaccari.com Status"
  monitor_ids = [
    uptimerobot_monitor.website.id,
  ]

  # Prevent search engine indexing
  no_index = true
}
