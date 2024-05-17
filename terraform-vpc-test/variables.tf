variable "Project_name" {
    default = "expense"

}

variable "Environment" {
  default = "dev"
}

variable "common_tags" {
  default = {
    Project_name="expense"
    Environment="dev"
    Terraform=true 

  }
}

variable "public_subnet_cidrs" {
  default = ["10.0.1.0/24","10.0.2.0/24"]
}



