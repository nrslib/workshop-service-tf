resource "local_file" "hints" {
  count = var.no_output ? 0 : 1

  filename = "${local.out_directory}/hints.yaml"
  content  = <<EOL
services:
  service-dns: ${module.services_service.dns_name}
development:
  env:
    ${var.application_name}: SPRING_DATASOURCE_DATABASE=${var.db_name};SPRING_DATASOURCE_HOST=localhost;SPRING_DATASOURCE_USERNAME=${var.rds_info.db_username};SPRING_DATASOURCE_PASSWORD=${module.mysql.db_password};SPRING_DATASOURCE_PORT=${var.db_port};SPRING_PROFILES_ACTIVE=${var.profile_active}
  gradle.properties: |
    jib.to.image=${var.aws_account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/${local.service_ecr_name}:latest
    aws.code-artifact.profile=${var.aws_profile}
  docker:
    login: aws ecr get-login-password --profile ${var.aws_profile} --region ${var.aws_region} | docker login --username AWS --password-stdin https://${var.aws_account_id}.dkr.ecr.ap-northeast-1.amazonaws.com
    push-command: docker push ${var.aws_account_id}.dkr.ecr.ap-northeast-1.amazonaws.com/${local.service_ecr_name}:latest

core-db:
  password: ${module.mysql.db_password}
  mysql install commands: |
    sudo yum remove -y mariadb-libs \
    && sudo yum localinstall -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm \
    && sudo yum-config-manager --disable mysql57-community \
    && sudo yum-config-manager --enable mysql80-community \
    && sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022 \
    && sudo yum install -y mysql-community-client
  mysql run command: mysql -h ${module.mysql.db_instance_address} -u ${var.rds_info.db_username} -p -P ${var.db_port}
EOL
}
