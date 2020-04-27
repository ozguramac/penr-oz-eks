# run `terraform output kubeconfig > ~/.kube/config` to use it for kubectl
output "kubeconfig" {
  description = "generate KUBECONFIG as output to save in ~/.kube/config locally"
  value = module.eks.kubeconfig
}