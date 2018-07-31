variable "host" {
  type        = "string"
  default     = "nodefault"
  description = "TODO"
}

variable "region" {
  type        = "string"
  default     = "tor1"
  description = "the digital ocean region."
}

variable "link_preview" {
  type        = "string"
  default     = "false"
  description = "TODO"
}

variable "do_token" {
  type        = "string"
  description = "the digital ocean access token. Steps to generate can be found at the following link: https://www.digitalocean.com/docs/api/create-personal-access-token/"
}

variable "pub_key" {
  type        = "string"
  description = "the file containing your digital ocean public key."
}

variable "pvt_key" {
  type        = "string"
  description = "the file containing your digital ocean private key."
}

variable "ssh_fingerprint" {
  type        = "string"
  description = "can be generated by running the following command: ssh-keygen -E md5 -lf PUBLIC_KEY_FILE | awk '{print $2}' | sed  's/MD5://'"
}
