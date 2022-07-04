data "terraform_remote_state" "ssh-keys" {
  backend = "remote"

  config = {
    hostname = "app.terraform.io"
    organization = "vadlapa"

    workspaces = {
      name = "ssh-keys"
    }
  }
}

module "server" {
  source                 = "app.terraform.io/example-org-5a4eda/server/aws"
  version                = "0.0.1"
  for_each               = local.servers
  server_os              = each.value.server_os
  identity               = each.value.identity
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.vpc_security_group_ids
  key_name               = data.terraform_remote_state.ssh-keys.outputs.key_name
}