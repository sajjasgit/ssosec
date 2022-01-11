terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "ssosec"

    workspaces {
      name = terraform.workspace
    }
  }
}