variable project {
  type        = string
  default     = "roboshop"
}

variable environment {
  type        = string
  default     = "dev"
}

variable cidr {
  type        = string
  default     = "10.0.0.0/24"
}

variable vpc_tags {
  type        = map
  default     = { }
}

variable igw_tags {
  type        = map
  default     = { }
}

variable pub_sub_cidr {
  type        = list
  default     = ["10.0.0.0/24","10.0.0.32/24"]
}

variable az_zone {
  type        = list
  default     = ["us-east-1a","us-east-1b"]
}

variable public_subnet_tags {
  type        = map
  default     = { }
}
