terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = "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"
  owner = "Practical-DevOps-GitHub"
}

resource "github_repository_collaborator" "repo_collaborator" {
  repository = "github-terraform-task-dnason"
  username   = "softservedata"
  permission = "admin"
}

resource "github_branch" "develop" {
	repository = "github-terraform-task-dnason" 
	branch = "develop"
}
resource "github_branch" "main" {
	repository = "github-terraform-task-dnason"
	branch = "main"
}
resource "github_branch_default" "default" {
	repository = "github-terraform-task-dnason"
	branch = "develop"
}

resource "github_repository_file" "codeowners" {
  repository          = "github-terraform-task-dnason"
  branch              = "main"
  file                = "CODEOWNERS"
  content             = "*       @softservedata"
  overwrite_on_create = true
}
  
resource "github_repository_file" "pull_request_template" {
  repository    = "github-terraform-task-dnason"
  branch        =  "main"
  overwrite_on_create = true
  file          = "pull_request_template.md"
  content       = <<-EOT
            ## Describe your changes
             
 
            ## Issue ticket number and link
            
            ## Checklist before requesting a review
            - [ ] I have performed a self-review of my code
            - [ ] If it is a core feature, I have added thorough tests
            - [ ] Do we need to implement analytics?
            - [ ] Will this be part of a product update? If yes, please write one phrase about this update
        EOT
}

resource "github_branch_protection" "protect_develop" {
  repository_id                   = "github-terraform-task-dnason"
  pattern                         = github_branch.develop.branch
  require_conversation_resolution = true
  enforce_admins                  = true

  required_pull_request_reviews {
    required_approving_review_count = 2
  }
}
resource "github_branch_protection" "protect_main" {
  repository_id			= "github-terraform-task-dnason"
  pattern			= github_branch.main.branch
  required_pull_request_reviews{
	#required_approving_review_count = 
 	require_code_owner_reviews 	= true
  }
}

resource "github_repository_deploy_key" "my_deploy_key" {
  title      = "DEPLY_KEY"
  repository = "github-terraform-task-dnason"
  key        = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCtIWeno465/RJ/CI60AIWQF876gkgyumBkIQzaFBBbgAllt61VZIHNZXxEHUhE1YnZwj+V8o5J2TsywUi3dhtezeOSJu352nsUdeLQ0O3X0g35LOTz/naYD07tav99bjju9GBWBjrwQW5/lY0wmkjkXUkzyCgd7Dp8pNDAta7MwJ68w/2nkFDqUualMFeRPW0YiDQeTztE3b/VAFYRusGhUsj0Fu5yTm1davwyCXCFNtA3MR05YLQ9xoO+t4uvi2jNv3afkeIgAMZ2ZhgStLl0yLJbyFXN5tvrSKvZE/LA7Vyc77rHu86Klru/uykMyvX1Qiw2Y3ByPghyLQTVdga2RfF66STLPWxL0zuS3sbXc2cnRWZhGr5QwYPaM45VqvT3aQxLX0EkzAQ7+8O0lGpVE1hMutPAOUMLqu5R1U9sSvmXC2l7xHEmr9hSz8Cq/w+cH/UfVOsP6Gz+h+9hkqcVcOLORvocjTkXtaWRlRf5V47+u3J5ADLOqJSyE+VvDdaKYr8CFzMpIzzCZos7hL/o2Se5oravF6I82Sg0dDb12294oxPutLcdpHWCJFmTFZCO4PGUBdOamm2vtf7X7Fmso8gtnqm/K2bXkaEKz/z8As2Aas94S0DYS41KA2+LbqQ0bSNDJWyzk8KDDwCYPYRhlrV0Af7nUseVFStIgjwWZw=="
  read_only  = "false"
}

resource "github_repository_webhook" "discord_hook" {
  repository = "github-terraform-task-dnason"

  configuration {
    url          = "https://discord.com/api/webhooks/1137452478489690212/X2Y--_9XvTjv5aD90OPmsr4RKGsCM3_7KjBHEr8AbqJjHHC7GenIjxDDjA4al4qpO-oi/github"
    content_type = "json"
    insecure_ssl = false
  }

  active = true

  events = ["pull_request"]
}
