resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags   = var.tags
}

# create versioning for the bucket
resource "aws_s3_bucket_versioning" "this" {
  # create this resource only if var.versioning is not empty
  count = var.enable_versioning ? 1 : 0

  bucket = aws_s3_bucket.this.id

  # enable versioning
  versioning_configuration {
    status = "Enabled"
  }
}

# Create a server-side encryption configuration for the bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  # create this resource only if var.sse_algorithm is not empty
  count = var.sse_algorithm != "" ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.sse_algorithm == "aws:kms" ? aws_kms_key.custom_s3_kms_key[0].key_id : null
      sse_algorithm     = var.sse_algorithm
    }
  }
}

# block public access
resource "aws_s3_bucket_public_access_block" "this" {

  # create this resource only if var.block_public_access is true
  count = var.block_public_access ? 1 : 0

  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.enable_website_configuration ? 1 : 0
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.website_index_document
  }

  error_document {
    key = var.website_error_document
  }
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
  count  = var.enable_website_configuration ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.website_bucket_policy[0].json
}

data "aws_iam_policy_document" "website_bucket_policy" {
  count = var.enable_website_configuration ? 1 : 0
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]

  }
}


resource "aws_kms_key" "custom_s3_kms_key" {
  count               = var.sse_algorithm == "aws:kms" ? 1 : 0
  description         = "Custom KMS key for s3 bucket encryption"
  enable_key_rotation = true
}

resource "aws_kms_alias" "a" {
  count         = var.sse_algorithm == "aws:kms" ? 1 : 0
  name          = "alias/s3-${replace(aws_s3_bucket.this.bucket, ".", "-")}"
  target_key_id = aws_kms_key.custom_s3_kms_key[0].key_id
}

resource "aws_kms_key_policy" "custom_s3_key_policy" {
  count  = var.sse_algorithm == "aws:kms" ? 1 : 0
  key_id = aws_kms_key.custom_s3_kms_key[0].id
  policy = data.aws_iam_policy_document.custom_s3_key_policy.json
}

data "aws_iam_policy_document" "custom_s3_key_policy" {
  statement {
    actions = [
      "kms:DescribeKey",
      "kms:ReEncrypt*",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    effect    = "Allow"
    resources = ["*"]
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
  # Allows key management using AWS IAM
  statement {
    actions = [
      "kms:*"
    ]
    effect    = "Allow"
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

data "aws_caller_identity" "current" {}


output "bucket_name" {
  value = aws_s3_bucket.this.id
}

output "arn" {
  value = aws_s3_bucket.this.arn
}

output "kms_arn" {
  value = var.sse_algorithm == "aws:kms" ? aws_kms_key.custom_s3_kms_key[0].arn : null
}

output "bucket_website_endpoint" {
  value = var.enable_website_configuration ? aws_s3_bucket_website_configuration.this[0].website_endpoint : null
}
