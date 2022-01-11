terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "TFE-CHIP"

    workspaces {
      # name = terraform.workspace
      name = "ssosec"
    }
  }
}