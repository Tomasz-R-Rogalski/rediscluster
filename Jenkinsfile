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
                        sh "aws eks update-kubeconfig --region eu-central-1 --name tomekcluster"
                        sh "kubectl apply -f redis-svc.yaml;kubectl apply -f redis-sts.yaml;kubectl apply -f test-pod.yaml"
                        sh "kubectl apply -k \"github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.35\""
                        sh "kubectl exec -it redis-cluster-0 -- redis-cli --cluster create --cluster-replicas 1 \$(kubectl get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' | sed 's/6379 :6379/6379/');yes"
                        sleep(time:30,unit:"SECONDS")
                    }
                }
            }
        }
        stage("Stage 3 Destroy clusters") {
            steps {
                script {
                    dir('terraform') {
                        sh "terraform destroy -auto-approve"
                    }
                }
            }
        }
    }
}
