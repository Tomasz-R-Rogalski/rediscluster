#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = "eu-central-1"
    }
    stages {
  //      stage("Stage 1 Create an EKS Cluster") {
    //        steps {
      //          script {
        //            dir('terraform') {
          //              sh "terraform init"
            //            sh "terraform apply -auto-approve"
              //      }
//                }
  //          }
    //    }
      //  stage("Stage 2 Deploy Redis Cluster") {
        //    steps {
          //      script {
            //        dir('redis') {
              //          sh "aws eks update-kubeconfig --region eu-central-1 --name tomekcluster"
                //        sh "kubectl apply -f redis-svc.yaml;kubectl apply -f redis-sts.yaml;kubectl apply -f test-pod.yaml;kubectl apply -k \"github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.35\""
                  //      sleep(time:3,unit:"MINUTES")
                    //    sh "kubectl exec -i redis-cluster-0 -- redis-cli --cluster create --cluster-yes --cluster-replicas 1 \$(kubectl get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' | sed 's/6379 :6379/6379/')"
                        //sh "kubectl exec -i redis-client -- redis-cli -h redis-cluster;SET mykey \"KluczNumeroUno\";GET mykey"
  //                  }
    //            }
      //      }
        //}
        stage("Stage 3 Destroy clusters") {
            steps {
                script {
                    dir('terraform') {
                     //   sh "terraform destroy -auto-approve"
                        sh "aws ec2 describe-volumes | grep 'VolumeId' | sed -r 's/.*VolumeId\": \"([^\"]*)\",/\1,/'"
                        list = "aws ec2 describe-volumes | grep 'VolumeId' | sed -r 's/.*VolumeId\": \"([^\"]*)\",/\1,/' | tr -d '\n' | sed -r 's/([^\"]*)/[\1]/'"
                        deleteVolumes(list)
                    }
                }
           }
        }
    }
}
@NonCPS 
def deleteVolumes(list) {
    list.each { item ->
        sh "aws ec2 delete-volume --volume-id ${item}"
    }
}
