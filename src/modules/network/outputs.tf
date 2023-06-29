output "vpc" {
  value = {
    vpc_id          = aws_vpc._.id
    private_subnets = [for s in aws_subnet.private_subnets : s.id]
    public_subnets  = [for s in aws_subnet.public_subnets : s.id]
  }
}

output "ecs_cluster_id" {
  value = module.ecs.ecs_cluster_id
}

output "ecs_cluster_name" {
  value = module.ecs.ecs_cluster_name
}