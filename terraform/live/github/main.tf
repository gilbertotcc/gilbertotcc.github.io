terraform {
  backend "gcs" {
    bucket = "gilbertotaccaricom-tfstate"
    prefix = "live/github"
  }
}

provider "github" {
  owner = "gilbertotcc"
}

resource "github_repository" "gilbertotcc_github_io" {
  name         = "gilbertotcc.github.io"
  description  = "Gilberto's personal website"
  homepage_url = "https://gilbertotaccari.com"

  visibility = "public"

  has_issues      = true
  has_discussions = false
  has_projects    = false
  has_wiki        = false

  delete_branch_on_merge = true

  vulnerability_alerts = true

  pages {
    build_type = "workflow"
    cname      = "gilbertotaccari.com"
  }

  security_and_analysis {
    secret_scanning {
      status = "enabled"
    }
    secret_scanning_push_protection {
      status = "enabled"
    }
  }
}

resource "github_repository_collaborator" "gilbertotcc_github_io" {
  for_each = toset([
    "iamleot",
  ])
  repository = github_repository.gilbertotcc_github_io.name
  username   = each.value
  permission = "push"
}

resource "github_branch_default" "gilbertotcc_github_io" {
  repository = github_repository.gilbertotcc_github_io.name
  branch     = "main"
}

resource "github_branch_protection" "gilbertotcc_github_io" {
  repository_id = github_repository.gilbertotcc_github_io.node_id
  pattern       = github_branch_default.gilbertotcc_github_io.branch
}

resource "github_repository_topics" "gilbertotcc_github_io" {
  repository = github_repository.gilbertotcc_github_io.name
  topics     = ["github-pages", "website"]
}

resource "github_repository_webhook" "gilbertotcc_github_io" {
  repository = github_repository.gilbertotcc_github_io.name

  configuration {
    url          = "${var.discord_webhook_url}/github"
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  # Supported events by Discord:
  # https://docs.discord.com/developers/resources/webhook#execute-github-compatible-webhook
  events = [
    "issues",
    "issue_comment",
    "pull_request",
    "pull_request_review",
    "pull_request_review_comment"
  ]
}

# Set the variable in your environment as TF_VAR_discord_webhook_url
variable "discord_webhook_url" {
  description = "Discord webhook URL for notifications"
  type        = string
  sensitive   = true
}
