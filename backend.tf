terraform {
    backend "s3" {
        bucket = "terraform-bucket-projec1"
        key = "terraform.tfstate"
        region ="ap-south-1"
    }
}