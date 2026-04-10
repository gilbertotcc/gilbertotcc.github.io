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
