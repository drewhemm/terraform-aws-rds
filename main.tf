# AWS.RDS.20
resource "random_integer" "port" {
  min = 49152
  max = 65535
}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  auto_minor_version_upgrade = true # AWS.RDS.16

  copy_tags_to_snapshot = true # AWS.RDS.17

  identifier = var.instance_identifier

  engine                = var.engine_name
  engine_version        = var.engine_version
  instance_class        = var.instance_class
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.allocated_storage * 2 # AWS.RDS.23

  name     = var.database_name
  username = var.username
  password = var.password
  port     = random_integer.port.result # AWS.RDS.20

  iam_database_authentication_enabled = true # AWS.RDS.15

  vpc_security_group_ids = var.security_group_ids

  maintenance_window       = var.maintenance_window
  backup_window            = var.environment_type == "prod" ? var.backup_window : null # AWS.RDS.21
  delete_automated_backups = var.environment_type == "prod" ? false : true             # AWS.RDS.21

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval                   = "30"
  monitoring_role_name                  = "MyRDSMonitoringRole"
  performance_insights_enabled          = var.environment_type == "prod" ? true : false # AWS.RDS.14
  performance_insights_retention_period = var.performance_insights_retention_period
  create_monitoring_role                = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids = var.subnet_ids # AWS.RDS.18

  # DB parameter group
  family = var.family

  # DB option group
  major_engine_version = var.major_engine_version

  # Database Deletion Protection
  deletion_protection = var.environment_type == "prod" ? true : false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]


  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
