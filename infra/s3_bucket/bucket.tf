variable "environments" {
  default = {
    develop = "develop"
    staging = "staging"
    main    = "main"
  }
}
resource "aws_s3_bucket" "bucket" {
  for_each = var.environments
  bucket = "frontend-devops-${each.value}"
}
resource "aws_s3_bucket_public_access_block" "permissions" {
  for_each = var.environments
  bucket = aws_s3_bucket.bucket[each.value].id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "static_website" {
  for_each = var.environments
  bucket = aws_s3_bucket.bucket[each.value].id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
  depends_on = [aws_s3_bucket.bucket]
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  for_each = var.environments
bucket = aws_s3_bucket.bucket[each.value].id
versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  for_each = var.environments
  bucket = aws_s3_bucket.bucket[each.value].id
  policy =  jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:AbortMultipartUpload",
                "s3:PutObjectVersionAcl",
                "s3:DeleteObject",
                "s3:PutObjectAcl",
                "s3:ListMultipartUploadParts"
            ],
            "Resource": [
                "arn:aws:s3:::frontend-devops-${each.value}",
                "arn:aws:s3:::frontend-devops-${each.value}/*"
            ]
        }
    ]
})
}


