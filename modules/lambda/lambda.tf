### EXECUTION ROLE ###
resource "aws_iam_role" "lambdas_role" {
  name               = "image_processor_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "lambdas_role_policy_attach" {
  role       = aws_iam_role.lambdas_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambdas_role_s3_policy_attach" {
  role       = aws_iam_role.lambdas_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

### LAMBDA ###
resource "aws_lambda_function" "image_processor" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "package.zip"
  function_name = "image_processor"
  role          = aws_iam_role.lambdas_role.arn
  handler       = "processor.image_processor"
  timeout       = 30

  source_code_hash = data.archive_file.image_processor_zip.output_base64sha256

  runtime = "python3.9"
}

data "archive_file" "image_processor_zip" {
  type        = "zip"
  source_dir  = "${path.module}/code/"
  output_path = "package.zip"
}

### LOG GROUP ###
resource "aws_cloudwatch_log_group" "image_processor_logs" {
  name              = "/aws/lambda/${aws_lambda_function.image_processor.function_name}"
  retention_in_days = 7
}
