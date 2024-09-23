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
                    dir('redis') {
                        sh "aws eks update-kubeconfig --region eu-central-1 --name tomekcluster"
                        sh "kubectl apply -f redis-svc.yaml;kubectl apply -f redis-sts.yaml;kubectl apply -f test-pod.yaml;kubectl apply -k \"github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.35\""
                        sleep(time:30,unit:"SECONDS")
                        sh "terraform destroy -auto-approve"
                    }
                }
            }
        }
        stage("Stage 2 Deploy Redis Cluster") {
            steps {
                script {
                    dir('redis') {
                        sleep(time:30,unit:"SECONDS")
                    }
                }
            }
        }
    }
}
