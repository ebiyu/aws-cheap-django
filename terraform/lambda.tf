# Lambda IAM Role
resource "aws_iam_role" "lambda_exec_role" {
  name               = "lambda_exec_role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  ]
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Lambda function using ECR image
resource "aws_lambda_function" "http_lambda" {
  function_name = "${local.prefix}-http-lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.this.repository_url}:v3"

  memory_size = 128
  timeout     = 10
}

# Lambda Function URL
resource "aws_lambda_function_url" "lambda_url" {
  function_name      = aws_lambda_function.http_lambda.function_name
  authorization_type = "NONE"

  # cors {
  #   allow_origins = ["*"]
  #   allow_methods = ["GET", "POST", "OPTIONS"]
  #   allow_headers = ["*"]
  # }
}

output "lambda_function_url" {
  value = aws_lambda_function_url.lambda_url.function_url
}
