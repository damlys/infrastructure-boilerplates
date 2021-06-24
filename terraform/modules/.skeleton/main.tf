module "foo_module" {
  source = "./foo"
  version = ">= 1.0.0, < 2.0.0"
  providers = {
    aws = aws.foo
  }

}

data "foo" "foo_data" {
  provider = aws.foo

}

resource "foo" "foo_resource" {
  provider = aws.foo

}

resource "bar" "bar_resource" {
  provider = aws.bar

  foo_module_name = module.foo_module.name
  foo_data_name = data.foo.foo_data.name
  foo_resource_name = foo.foo_resource.name
}
