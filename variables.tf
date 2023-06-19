variable "namespace" {
  description = "The project namespace to use for unique resource naming"
  default     = "terraform-module"
  type        = string
}

variable "region" {
  description = "AWS region"
  default     = "us-east-2"
  type        = string
}
