variable project {
  type        = "string"
  default     = "roboshop"
}

variable environment {
  type        = "string"
  default     = "dev"
}

variable cidr {
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable vpc_tags {
  type        = "map"
  default     = { }
}

variable igw_tags {
  type        = "map"
  default     = { }
}