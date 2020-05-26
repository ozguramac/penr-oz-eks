# Penr-oz EKS Cluster

### Reference Documentation
For further reference, please consider the following sections:

* [Terraform Intro](https://www.terraform.io/intro/index.html)
* [Terraform EKS](https://learn.hashicorp.com/terraform/aws/eks-intro)
* [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [Building AWS EKS using Terraform](https://www.esentri.com/building-a-kubernetes-cluster-on-aws-eks-using-terraform/)
* [Provision EKS Cluster using Terraform](https://learn.hashicorp.com/terraform/kubernetes/provision-eks-cluster)
* [Creating AWS Cert using Terraform](https://www.azavea.com/blog/2018/07/16/provisioning-acm-certificates-on-aws-with-terraform/)
* [Terraform AWS VPC Module](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.28.0)
* [Terraform AWS EKS Module](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/11.1.0)
* [Terraform AWS ALB Module](https://registry.terraform.io/modules/terraform-aws-modules/alb/aws/5.0.0)
* [Terraform AWS Security-Group Module](https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/3.8.0)
* [Terraform AWS ACM Cert Module](https://registry.terraform.io/modules/terraform-aws-modules/acm/aws/2.5.0)
* [Terraform AWS ALB Ingress Controller](https://registry.terraform.io/modules/iplabs/alb-ingress-controller/kubernetes/3.2.0)
* [Kubernetes External DNS](https://github.com/kubernetes-sigs/external-dns/releases/tag/v0.5.15)

### Additional Links
These additional references should also help you:

* [AWS EKS](https://aws.amazon.com/eks/getting-started/)
* [AWS IAM Auth](https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)
* [Kubectl Autocomplete](https://kubernetes.io/docs/tasks/tools/install-kubectl/#enabling-shell-autocompletion)
* [jq](https://stedolan.github.io/jq/)
* [Subdomain in Route53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingNewSubdomain.html#CreateZoneNewSubdomain)
* [Define EC2 KeyPair](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html)
* [Troubleshoot Newly Creates EKS cluster](https://medium.com/@yocollab/terraform-creating-eks-cluster-f5f53ebd0f1b)
* [EKS API Server Unauthorized](https://aws.amazon.com/premiumsupport/knowledge-center/eks-api-server-unauthorized-error/)

## Download and Installation
* [Fork, Clone, or Download on GitHub](https://github.com/ozguramac/penr-oz-eks)

### Init
```
$ terraform init
```
### Plan
```
$ terraform plan
```
### Apply
```
$ terraform apply
```
Known issue first `apply` run will fail with multiple errors like this one:
```
Error: Post "https://xxxxxxxxxxxxx.eks.amazonaws.com/api/v1/namespaces/kube-system/configmaps": dial tcp: lookup
 xxxxxxxxxxxxxxxx.eks.amazonaws.com on 127.0.1.1:53: no such host
```
follow it with `$ terraform output kubeconfig > ~/.kube/config`
and then a subsequent `$ terraform apply` will start reaching the cluster

### Who do I talk to? ###
* Repo owner or [admin](mailto:info@derinworksllc.com) 

## Copyright and License
&copy; Copyright 2020 [Derin Works LLC](http://www.derinworksllc.com)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)