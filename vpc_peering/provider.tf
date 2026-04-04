provider "aws" {
  region = var.primary
  alias = "primary"
}
provider "aws" {
  region = var.secondary
  alias = "secondary"
}