module "storage" {
  source = "./modules/s3"
}

module "resize_lambda" {
  source = "./modules/lambda"
}
