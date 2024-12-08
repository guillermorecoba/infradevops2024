
resource "aws_lambda_function" "email_cicd" {
    filename         = "./lambda_function.zip"
    function_name    = "email_cicd"
    runtime          = "python3.13"
    role = "arn:aws:iam::975050210892:role/LabRole"
    handler = "lambda_function.lambda_handler"
    environment {
        variables = {
            SENDER_EMAIL = "lineage2reforged@gmail.com"
            SENDER_PASSWORD = "zsdombmzngcxytmm"
            RECEIVER_EMAIL = "guirever@gmail.com"
        }
    }
}

resource "aws_lambda_permission" "allow_s3" {
    statement_id  = "AllowS3Invoke"
    action        = "lambda:InvokeFunction"
    function_name = aws_lambda_function.email_cicd.function_name
    principal     = "s3.amazonaws.com"

}

resource "aws_s3_bucket_notification" "bucket_notification" {
    for_each = var.environments
    bucket = aws_s3_bucket.bucket[each.value].id
    
    lambda_function {
        lambda_function_arn = aws_lambda_function.email_cicd.arn
        events              = ["s3:ObjectCreated:*"]
        filter_suffix       = ".html"
    }

    depends_on = [aws_s3_bucket.bucket,aws_lambda_function.email_cicd, aws_lambda_permission.allow_s3]
}

# resource "aws_iam_role" "lambda_exec" {
#     name = "lambda_exec_role"

#     assume_role_policy = jsonencode({
#         Version = "2012-10-17"
#         Statement = [
#             {
#                 Action = "sts:AssumeRole"
#                 Effect = "Allow"
#                 Principal = {
#                     Service = "lambda.amazonaws.com"
#                 }
#             }
#         ]
#     })
# }

# resource "aws_iam_role_policy" "lambda_exec_policy" {
#     name   = "lambda_exec_policy"
#     role   = aws_iam_role.lambda_exec.id

#     policy = jsonencode({
#         Version = "2012-10-17"
#         Statement = [
#             {
#                 Action = [
#                     "logs:CreateLogGroup",
#                     "logs:CreateLogStream",
#                     "logs:PutLogEvents"
#                 ]
#                 Effect   = "Allow"
#                 Resource = "arn:aws:logs:*:*:*"
#             },
#             {
#                 Action = "s3:GetObject"
#                 Effect = "Allow"
#                 Resource = "${aws_s3_bucket.static_website.arn}/*"
#             }
#         ]
#     })
# }
