# RDS
module "db" {
  source = "registry.terraform.io/terraform-aws-modules/rds/aws"

  identifier = "${var.prefix}-${var.application_name}-${var.db_name}"

  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family
  major_engine_version = var.major_engine_version
  instance_class       = var.db_instance
  allocated_storage    = 5

  db_name                     = var.db_name
  username                    = var.db_username
  manage_master_user_password = false
  password                    = random_password.db.result
  port                        = var.db_port

  publicly_accessible = var.publicly_accessible

  monitoring_interval    = "30"
  monitoring_role_name   = "${var.prefix}-MyRDSMonitoringRole-${var.application_name}-${var.db_name}"
  create_monitoring_role = true

  create_db_subnet_group = false
  db_subnet_group_name   = aws_db_subnet_group.database_rds_subnet_group.name
  subnet_ids             = var.vpc_private_subnets
  skip_final_snapshot    = true

  apply_immediately = var.db_apply_immediately

  vpc_security_group_ids = [var.db_security_group_id]

  tags = {
    Name = "${var.prefix}-rds-db-${var.application_name}"
  }
}

resource "aws_db_subnet_group" "database_rds_subnet_group" {
  name        = "${var.prefix}-rds-${var.db_name}-subnet-${var.application_name}"
  description = "RDS subnet group for ${var.prefix}-${var.application_name}.${var.db_name}"
  subnet_ids  = var.vpc_private_subnets

  tags = {
    Name = "${var.prefix}-rds-subnet-${var.application_name}"
  }
}

/*
 * DB Secrets Manager
 */
resource "random_password" "db" {
  length           = 16
  special          = true
  override_special = "_!%^"
}

resource "aws_secretsmanager_secret" "db" {
  name = "${var.prefix}-db-${var.application_name}-${var.db_name}"

  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db" {
  secret_id     = aws_secretsmanager_secret.db.id
  secret_string = jsonencode({
    username             = var.db_username
    password             = random_password.db.result
    engine               = "mysql"
    host                 = module.db.db_instance_address
    port                 = var.db_port
    dbInstanceIdentifier = "${var.prefix}-${var.application_name}-${var.db_name}"
  })
}
