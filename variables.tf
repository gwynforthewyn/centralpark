#"67.176.80.56/32" - gwyn
variable "allowed_ingress" {
  type = list(string)

  default = ["67.176.80.56/32"]
  description = "IP addresses allowed to access network resources."
}