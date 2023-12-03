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

resource "aws_iam_role" "lambdas_role" {
  name               = "lambdas_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "archive_file" "image_processor_zip" {
  type        = "zip"
  source_dir  = "code/"
  output_path = "package.zip"
}

resource "aws_lambda_function" "image_processor" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "package.zip"
  function_name = "image_processor"
  role          = aws_iam_role.lambdas_role.arn
  handler       = "image_processor.image_processor"

  source_code_hash = data.archive_file.image_processor_zip.output_base64sha256

  runtime = "python3.9"
}
