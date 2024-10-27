#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "eu-central-1"
    }
    stages {
        stage("Stage 1 Create an EKS Cluster") {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform init"
                        sh "terraform apply -auto-approve"
                    }
                }
            }
        }
        stage("Stage 2 Deploy Redis Cluster") {
            steps {
                script {
                    dir('redis') {
                        sh "aws eks update-kubeconfig --region eu-central-1 --name redis-cluster"
                       // sh "helm install my-aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver --version 2.36.0;helm install redis-chart redis-chart"
                      //  sh "helm upgrade --install aws-ebs-csi-driver --namespace kube-system aws-ebs-csi-driver/aws-ebs-csi-driver"
                        sh "helm upgrade --install aws-load-balancer-controller eks-charts/aws-load-balancer-controller   --version \"1.9.2\"   --namespace \"kube-system\"   --set \"clusterName=redis-cluster\"   --set \"serviceAccount.name=aws-load-balancer-controller-sa\"   --set \"serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn\"=\"\$LBC_ROLE_ARN\"   --wait"
                        sh "helm install redis-chart redis-chart;kubectl apply -k \"github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.36\""
                     //   sh "helm repo add eks https://aws.github.io/eks-charts; helm repo update eks; helm upgrade aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=redis-cluster --set serviceAccount.create=false --set region=eu-central-1 --set vpcId=vpc-077d11d3eeecf2188 --set serviceAccount.name=aws-load-balancer-controller"
                        //           sleep(time:3,unit:"MINUTES")
                        //sh "kubectl exec -i redis-cluster-0 -- redis-cli --cluster create --cluster-yes --cluster-replicas 1 \$(kubectl get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' | sed 's/6379 :6379/6379/')"
                   //     sleep(time:20,unit:"MINUTES")
                    }
                }
            }
        }
        stage("Stage 3 Destroy clusters") {
            steps {
                script {
                    dir('terraform') {
             //          sh "kubectl delete svc redis-cluster-loadbalancer"
                        sh "terraform destroy -auto-approve"
                        sh "for K in \$(aws ec2 --region eu-central-1 describe-volumes --query 'Volumes[*].VolumeId' --output=text); do aws ec2 delete-volume --volume-id \$K; done"
                    }
                }
           }
        }
    }
}
