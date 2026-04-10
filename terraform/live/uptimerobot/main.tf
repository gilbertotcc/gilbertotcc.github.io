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

  assigned_alert_contacts = [
    {
      alert_contact_id = uptimerobot_integration.website_discord.id,
      threshold        = 0,
      recurrence       = 0
    }
  ]
}

resource "uptimerobot_psp" "webisite" {
  name = "gilbertotaccari.com Status"
  monitor_ids = [
    uptimerobot_monitor.website.id,
  ]

  # Prevent search engine indexing
  no_index = true
}

resource "uptimerobot_integration" "website_discord" {
  name                     = "Website Discord"
  type                     = "discord"
  value                    = var.discord_webhook_url
  enable_notifications_for = 1
  ssl_expiration_reminder  = false
}

# Set the variable in your environment as TF_VAR_discord_webhook_url
variable "discord_webhook_url" {
  description = "Discord webhook URL for notifications"
  type        = string
  sensitive   = true
}

resource "uptimerobot_psp" "webisite" {
  name = "gilbertotaccari.com Status"
  monitor_ids = [
    uptimerobot_monitor.website.id,
  ]

  # Prevent search engine indexing
  no_index = true
}

resource "uptimerobot_integration" "website_discord" {
  name                     = "Website Discord"
  type                     = "discord"
  value                    = var.discord_webhook_url
  enable_notifications_for = 1
  ssl_expiration_reminder  = false
}

# Set the variable in your environment as TF_VAR_discord_webhook_url
variable "discord_webhook_url" {
  description = "Discord webhook URL for notifications"
  type        = string
  sensitive   = true
}
