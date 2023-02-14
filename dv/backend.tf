terraform {
  cloud {
    organization = "LloydsPOC-Dev"

    workspaces {
      name = "GCPDemo1"
    }
  }
}