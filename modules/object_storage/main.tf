/**
 * Copyright © 2014-2022 HashiCorp, Inc.
 *
 * This Source Code is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this project, you can obtain one at http://mozilla.org/MPL/2.0/.
 *
 */

# resource "aws_s3_bucket" "vault_license_bucket" {
#   bucket_prefix = "${var.resource_name_prefix}-vault-license"

#   force_destroy = true

#   tags = var.common_tags
# }


# # Versioning configuration (moved out of aws_s3_bucket)
# resource "aws_s3_bucket_versioning" "vault_license_bucket_versioning" {
#   bucket = aws_s3_bucket.vault_license_bucket.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }

# # Server-side encryption configuration (moved out of aws_s3_bucket)
# resource "aws_s3_bucket_server_side_encryption_configuration" "vault_license_bucket_encryption" {
#   bucket = aws_s3_bucket.vault_license_bucket.id

#   rule {
#     apply_server_side_encryption_by_default {
#       kms_master_key_id = var.kms_key_arn
#       sse_algorithm     = "aws:kms"
#     }
#   }
# }

# # Public access block configuration
# resource "aws_s3_bucket_public_access_block" "vault_license_bucket" {
#   bucket = aws_s3_bucket.vault_license_bucket.id

#   block_public_acls       = true
#   block_public_policy     = true
#   restrict_public_buckets = true
#   ignore_public_acls      = true
# }

# # Upload license object to S3
# resource "aws_s3_bucket_object" "vault_license" {
#   bucket = aws_s3_bucket.vault_license_bucket.id
#   key    = var.vault_license_name
#   source = var.vault_license_filepath

#   tags = var.common_tags
# }






/**
 * Copyright © 2014-2022 HashiCorp, Inc.
 *
 * This Source Code is subject to the terms of the Mozilla Public License, v. 2.0.
 * If a copy of the MPL was not distributed with this project, you can obtain one at http://mozilla.org/MPL/2.0/.
 */

# Base S3 bucket creation (minimal)
resource "aws_s3_bucket" "vault_license_bucket" {
  bucket_prefix = "${var.resource_name_prefix}-vault-license"

  force_destroy = true

  tags = var.common_tags
}

# Optional (and recommended): set bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "vault_license_bucket_ownership" {
  bucket = aws_s3_bucket.vault_license_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Apply server-side encryption configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "vault_license_bucket_encryption" {
  bucket = aws_s3_bucket.vault_license_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Enable versioning (modular)
resource "aws_s3_bucket_versioning" "vault_license_bucket_versioning" {
  bucket = aws_s3_bucket.vault_license_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Configure public access block
resource "aws_s3_bucket_public_access_block" "vault_license_bucket" {
  bucket = aws_s3_bucket.vault_license_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

# Upload license object
resource "aws_s3_bucket_object" "vault_license" {
  bucket = aws_s3_bucket.vault_license_bucket.id
  key    = var.vault_license_name
  source = var.vault_license_filepath

  tags = var.common_tags
}
