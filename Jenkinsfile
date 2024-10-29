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
                        sh "helm upgrade --install aws-load-balancer-controller eks-charts/aws-load-balancer-controller   --version \"1.9.2\"   --namespace \"kube-system\"   --set \"clusterName=redis-cluster\"   --set \"serviceAccount.name=aws-load-balancer-controller-sa\"   --set \"serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn\"=\"\$LBC_ROLE_ARN\"   --wait"
                        sh "helm install redis-chart redis-chart;kubectl apply -k \"github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.36\""
                        sh "kubectl exec -i redis-cluster-0 -- redis-cli --cluster create --cluster-yes --cluster-replicas 1 \$(kubectl get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:80 ' | sed 's/80 :80/80/')"
                        sleep(time:180,unit:"MINUTES") // Reservation time
                    }
                }
            }
        }
        stage("Stage 3 Destroy Cluster") {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform destroy -auto-approve"
                        sh "for K in \$(aws ec2 --region eu-central-1 describe-volumes --query 'Volumes[*].VolumeId' --output=text); do aws ec2 delete-volume --volume-id \$K; done"
                    }
                }
           }
        }
    }
}
