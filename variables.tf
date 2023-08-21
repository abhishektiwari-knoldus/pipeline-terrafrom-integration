variable "accessTier" {
  default = "Cool"
}

variable "repplication" {
  default = "LRS"
}

variable "actTier"{
  default = "Premium"
}

#container access type

variable "conAccessType" {
  default = "private"
}

#source for file upload

variable "sourceFile" {
  description = "Files coming from local"
}