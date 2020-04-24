output "eks_kubeconfig" {
  value = local.kubeconfig
  depends_on = [
    aws_eks_cluster.main
  ]
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "node_sg_id" {
  value = aws_security_group.main-node.id
}