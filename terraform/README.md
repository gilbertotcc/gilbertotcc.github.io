# Infrastructure as Code

In this directory, you can find the Infrastructure as Code (IaC) configuration
of the website, which uses OpenTofu.

IaC controls these infrastructural elements:

- GitHub repository
- Porkbun DNSes
- UptimeRobot

OpenTofu state is persisted on a GCS bucket.

## Requirements

To use IaC, you follow these steps.

- Install `gcloud` CLI and ensure you have the permissions to interact with GCP
  operations on the project where the OpenTofu state is persisted.
- Install the GitHub CLI, which the GitHub Terraform provider uses.
- Set the following environment variables:
  
  - `PORKBUN_API_KEY` and `PORKBUN_SECRET_KEY`, Porkbun credentials.
  - `UPTIMEROBOT_API_KEY`, UptimeRobot API key.
  - `TF_VAR_discord_webhook_url`, Discord webhook URL to allow UptimeRobot and
    GitHub to send events to Discord.

> NOTE: You can configure these variables in a `.env` file within this directory
> and use direnv to load them.
> (See [Tips & Tricks](../README.md#tips--tricks) in the main README file.)

For more information, see the providers’ documentation.
See the [References](#references) section below.

## Usage

In any of the directories in `live/`, you can find the configurations of GitHub,
Porkbun, and the OpenTofu state (in a GCS bucket).

Run `tofu init` to initialise the configuration, then use the usual OpenTofu
commands `plan` and `apply`  to plan the changes and apply them, respectively.

## References

- [GitHub Terraform provider](https://registry.terraform.io/providers/integrations/github/latest)
- [Porkbun Terraform provider](https://registry.terraform.io/providers/jianyuan/porkbun/latest)
- [UptimeRobot Terraform Provider](https://registry.terraform.io/providers/uptimerobot/uptimerobot/latest)
- [Discord | Intro to Webhooks](https://support.discord.com/hc/en-us/articles/228383668-Intro-to-Webhooks)
- [GitHub Docs | Webhook events and payloads](https://docs.github.com/en/webhooks/webhook-events-and-payloads)
