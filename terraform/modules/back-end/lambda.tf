#zip the python code
data "archive_file" "lambda" {
    type = "zip"
    source_file = "${path.module}/user_count_lambda.py"
    output_path = "${path.module}/user_count_lambda_function.zip"
}

#create the lambda funcion
resource "aws_lambda_function" "viewer_count_lambda_function" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename = "${path.module}/user_count_lambda_function.zip"
  function_name = var.viewer_count
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "user_count_lambda.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.13"

}

#Create role for Lambda Execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

}

#Policy to get access to dynamodb table and create log group
resource "aws_iam_policy" "table_count_access" {
  name        = "table_count_access"
  description = "Policy to get access to dynamodb table and create log group"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "logs:CreateLogGroup"
        Resource = "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = [
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${aws_lambda_function.viewer_count_lambda_function.function_name}:*"
        ]
      },
      {
        Effect   = "Allow"
        Action   = [
          "dynamodb:GetItem",
          "dynamodb:UpdateItem",
          "dynamodb:PutItem"
        ]
        Resource = aws_dynamodb_table.site_visitor_count.arn
      }
    ]
  })
}

#Attach the policy with role
resource "aws_iam_role_policy_attachment" "table_count_attach" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.table_count_access.arn
}

#Create cloudwatch log group to check error if occurs
resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.viewer_count_lambda_function.function_name}"
  retention_in_days = 7 # You can change to 1, 3, 5, 14, etc.

}
