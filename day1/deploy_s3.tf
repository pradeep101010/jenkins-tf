provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-jenkins-s3-${random_id.bucket_id.hex}"


  tags = {
    Name        = "Jenkins-S3-Bucket"
    Environment = "Dev"
  }
}

resource "random_id" "bucket_id" {
  byte_length = 4
}
