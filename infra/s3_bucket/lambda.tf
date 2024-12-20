
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

