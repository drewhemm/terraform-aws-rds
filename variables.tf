# ---------------------------------------------------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# Define these secrets as environment variables
# ---------------------------------------------------------------------------------------------------------------------

# AWS_ACCESS_KEY_ID
# AWS_SECRET_ACCESS_KEY

# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# Given these are credentials, security of the values should be considered.
# ---------------------------------------------------------------------------------------------------------------------
variable "region" {
  description = "The AWS region to deploy to"
  type        = string
}

variable "username" {
  description = "Master username of the DB"
  type        = string
}

variable "password" {
  description = "Master password of the DB"
  type        = string

  validation {
    condition = length(var.password) >= 8
    error_message = "The master password must be 8 characters or longer."
  }
}

variable "database_name" {
  description = "Name of the database to be created"
  type        = string
}

variable "instance_identifier" {
  description = "Identifier for the RDS instance"
  type        = string
}

variable "security_group_ids" {
  description = "Set of security group IDs to apply to the instance"
  type        = set(string)
}

variable "subnet_ids" {
  description = "Subnet IDs for where to create the subnet groups"
  type        = set(string)
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "name" {
  default     = "terratest-example"
  description = "Name of the database"
  type        = string
}

variable "engine_name" {
  default     = "mysql"
  description = "Name of the database engine"
  type        = string
}

variable "family" {
  default     = "mysql5.7"
  description = "Family of the database"
  type        = string
}

variable "port" {
  default     = 3306
  description = "Port which the database should run on"
  type        = number
}

variable "major_engine_version" {
  default     = "5.7"
  description = "MAJOR.MINOR version of the DB engine"
  type        = string
}

variable "engine_version" {
  default     = "5.7.21"
  description = "Version of the database to be launched"
  type        = string
}

variable "allocated_storage" {
  default     = 5
  description = "Disk space to be allocated to the DB instance"
  type        = number
}

variable "license_model" {
  default     = "general-public-license"
  description = "License model of the DB instance"
  type        = string
}

variable "instance_class" {
  default     = "db.t3.micro"
  description = "Instance class to be used to run the database"
  type        = string
}

variable "environment_type" {
  default = "nonprod"
  description = "Whether this RDS instance is used for prod or nonprod"
  type        = string

  validation {
    condition     = contains(["nonprod", "prod"], var.environment_type)
    error_message = "The environment type can be one of the following values: nonprod or prod."
  }
}

variable "backup_window" {
  default     = "03:00-06:00"
  description = "Window for automated backups"
  type        = string
}

variable "maintenance_window" {
  default     = "Mon:00:00-Mon:03:00"
  description = "Window for maintenance"
  type        = string
}

variable "performance_insights_retention_period" {
  default     = 7
  description = "Retention period for performance insight data"
  type        = number
}
