1. terraform apply
2. Add ec2fullaccess policy to nodegroup in IAM roles
3. aws eks update-kubeconfig --region eu-central-1 --name tomekcluster
4. kubectl apply -f redis-svc.yaml;kubectl apply -f redis-sts.yaml;kubectl apply -f test-pod.yaml;kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.35"
5. kubectl exec -it redis-cluster-0 -- redis-cli --cluster create --cluster-replicas 1 $(kubectl get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379 ' | sed 's/6379 :6379/6379/')
6. kubectl exec -it redis-client -- redis-cli -h redis-cluster -c

POST:
Usunac pvc dla redisa
