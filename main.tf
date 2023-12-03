module "storage" {
  source = "./modules/s3"
}

module "resize_lambda" {
  source     = "./modules/lambda"
  bucket_arn = module.storage.bucket_arn
  bucket_id  = module.storage.bucket_id
}
