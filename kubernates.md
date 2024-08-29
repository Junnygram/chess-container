

### 1. Install Kubernetes on Your Instance

Firstly, you need to install Kubernetes on your instance. You can read more about the installation process [here](https://eksctl.io/installation/).

If you're connecting to AWS outside the console (e.g., via CLI), make sure to connect to your IAM user and ensure you've attached the necessary policies to that user. This ensures that your user has the right permissions to create and manage Kubernetes resources on AWS.

```bash
curl -O https://github.com/Junnygram/chess-container/blob/main/kubeinstall.sh
chmod +x kubeinstall.sh
./kubeinstall.sh
```

**Explanation**: 
- The `curl -O` command downloads a script (`kubeinstall.sh`) from the provided URL.
- `chmod +x kubeinstall.sh` makes the script executable.
- `./kubeinstall.sh` runs the script to install Kubernetes and configure your environment.


#### step one not needed 

### 2. Create a Chess Application Kubernetes Manifest

To deploy a Chess application on Kubernetes, you'll first need to create a cluster and deploy the application.

#### Create a Chess Cluster using Fargate

```bash
eksctl create cluster --name chess-cluster --region us-east-1 --fargate
```

**Explanation**: 
- `eksctl create cluster` is a command that creates a new EKS (Elastic Kubernetes Service) cluster. 
- `--name chess-cluster` sets the name of your cluster to `chess-cluster`.
- `--region us-east-1` specifies the AWS region where the cluster will be created.
- `--fargate` means that your cluster will use AWS Fargate, which allows you to run Kubernetes pods without having to manage the underlying EC2 instances.

#### When you run the command `eksctl create cluster --name chess-cluster --region us-east-1 --fargate`, the following key components are created:

1. **EKS Cluster**: A managed Kubernetes control plane that handles scheduling, networking, and maintaining the desired state of your cluster.

2. **Fargate Profile**: Defines which pods run on AWS Fargate, allowing you to deploy containers without managing EC2 instances.

3. **VPC and Subnets**: Networking infrastructure that provides internal and external communication for the cluster.

4. **IAM Roles and Policies**: Permissions for the EKS cluster and Fargate to interact with AWS services.

5. **Security Groups**: Control inbound and outbound traffic to the cluster and its components.

6. **Kubernetes Resources**: Default namespaces and system pods that form the basic infrastructure for running workloads.

These components together enable a serverless Kubernetes environment, reducing the need for manual infrastructure management.




#### Update kubeconfig to Connect to the Cluster

```bash
aws eks update-kubeconfig --name chess-cluster --region us-east-1
```

**Explanation**: 
- This command updates your kubeconfig file to include the details of the newly created cluster. 
- The kubeconfig file is what Kubernetes uses to know how to communicate with your cluster. By updating it, you’re setting up your environment to interact with the `chess-cluster`.

#### Create a Fargate Profile

```bash
eksctl create fargateprofile \
    --cluster chess-cluster \
    --region us-east-1 \
    --name alb-sample-app \
    --namespace chess-deployment
```

**Explanation**:
- A Fargate profile defines which Kubernetes pods should run on Fargate.
- Here, `--cluster chess-cluster` specifies the cluster the profile is for.
- `--namespace chess-deployment` restricts the profile to only apply to pods within the `chess-deployment` namespace. This means only those pods will run on Fargate.
- Running on Fargate simplifies infrastructure management, enhances security by isolating each pod, and eliminates the need to manage the underlying servers (EC2 instances).

### 3. Deploy the Chess Application

Now that your environment is set up, you can deploy your Chess application.

```bash
kubectl apply -f https://raw.githubusercontent.com/Junnygram/chess-container/main/chess.yaml
kubectl get pods -n chess-deployment
```

**Explanation**: 
- `kubectl apply -f` downloads and applies the Kubernetes configuration from the `chess.yaml` file.
- This file defines the deployment of your Chess application, including how many instances (replicas) of the application should run.
- `kubectl get pods -n chess-deployment` lists all the pods running in the `chess-deployment` namespace. Since you have specified `replicas: 2` in the YAML file, you should see two pods.

### 4. Create an IAM Policy for AWS Load Balancer Controller

To use an AWS Load Balancer with your Kubernetes service, you need to create the necessary IAM policy.

```bash
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json
```

**Explanation**:
- This command downloads the IAM policy JSON file required for the AWS Load Balancer Controller.

```bash
aws iam create-policy \
--policy-name AWSLoadBalancerControllerIAMPolicy \
--policy-document file://iam_policy.json
```

**Explanation**:
- `aws iam create-policy` creates a new IAM policy in your AWS account using the downloaded JSON file.
- This policy allows the AWS Load Balancer Controller to manage load balancers on your behalf.

### 5. Create an IAM Role for AWS Load Balancer Controller

```bash
eksctl create iamserviceaccount \
  --cluster=chess-cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
```

**Explanation**:
- This command creates an IAM role and associates it with the Kubernetes service account `aws-load-balancer-controller` in the `kube-system` namespace of your cluster.
- The role has the necessary permissions (as defined by the IAM policy) to manage AWS resources like load balancers.

### 6. Install Helm (if not already installed)

```bash
brew install helm
```

**Explanation**:
- This command installs Helm, a package manager for Kubernetes that simplifies the deployment and management of applications within a Kubernetes cluster.

### 7. Add and Update the Helm Repository

```bash
helm repo add eks https://aws.github.io/eks-charts
```

**Explanation**:
- This command adds the AWS EKS Helm chart repository, which contains Helm charts specifically for EKS.

```bash
helm repo update eks
```

**Explanation**:
- This command updates the local list of available charts from the EKS Helm repository, ensuring you have the latest versions.

### 8. Install the AWS Load Balancer Controller

Finally, install the AWS Load Balancer Controller using Helm.

```bash
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=chess-cluster --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller --set region=us-east-1 --set vpcId=vpc-0556fd5afb69db27a
```

**Explanation**:
- `helm install` installs the AWS Load Balancer Controller using the Helm chart from the `eks` repository.
- `--set clusterName=chess-cluster`, `--set region=us-east-1`, and `--set vpcId=vpc-0556fd5afb69db27a` specify the cluster name, region, and VPC ID where the load balancer should be set up.

```bash
kubectl get deployment -n kube-system aws-load-balancer-controller -w
```

**Explanation**:
- This command checks the status of the AWS Load Balancer Controller deployment in the `kube-system` namespace. The `-w` flag watches for updates, so you can see when the controller is fully deployed.

### 9. Access Your Chess Application

Once the AWS Load Balancer Controller is set up, your Chess application will be accessible via the load balancer’s address, which you can obtain from the AWS Management Console under the ELB (Elastic Load Balancer) section.
