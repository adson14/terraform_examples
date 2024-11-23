provider "aws" {
  region = "ap-south-1"
}


variable "bucket_name" {
  type = string
}

resource "aws_s3_bucket" "static_site_bucket" {
  bucket = "static-site-${var.bucket_name}"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = {
    Name        = "static-site-${var.bucket_name}"
    Environment = "Aprendizado"
  }
}



resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.static_site_bucket.bucket
  key          = "index.html"                       # Nome do arquivo no bucket
  source       = "../../static/index.html"          # Caminho local para o arquivo
  content_type = "text/html"                        # Tipo de conteúdo
  etag         = filemd5("../../static/index.html") # Calcula o hash do arquivo
}

resource "aws_s3_object" "error_html" {
  bucket       = aws_s3_bucket.static_site_bucket.bucket
  key          = "404.html"
  source       = "../../static/404.html"
  content_type = "text/html"
  etag         = filemd5("../../static/404.html") # Calcula o hash do arquivo
}

resource "null_resource" "upload_site" {
  provisioner "local-exec" {
    command = "aws s3 sync ../../static s3://${aws_s3_bucket.static_site_bucket.bucket} --delete --acl public-read"
  }
}


resource "aws_s3_bucket_public_access_block" "static_site_bucket" {
  bucket = aws_s3_bucket.static_site_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "static_site_policy" {
  bucket = aws_s3_bucket.static_site_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.static_site_bucket.arn}/*"
      }
    ]
  })
}


resource "aws_s3_bucket_ownership_controls" "static_site_bucket" {
  bucket = aws_s3_bucket.static_site_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static_site_bucket_acl" {
  depends_on = [
    aws_s3_bucket_public_access_block.static_site_bucket,
    aws_s3_bucket_ownership_controls.static_site_bucket
  ]

  bucket = aws_s3_bucket.static_site_bucket.id
  acl    = "public-read"
}


output "url_bucket" {
  value = resource.aws_s3_bucket.static_site_bucket.website_endpoint
}



