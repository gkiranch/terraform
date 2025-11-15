variable "region" {
   type    = string
   default = "us-east-1"
 }
 
 variable "cluster_name" {
   type = string
 }
 
 variable "cluster_version" {
   type    = string
   default = "1.30"
 }
 
 variable "vpc_cidr" {
   type    = string
   default = "10.0.0.0/16"
 }
