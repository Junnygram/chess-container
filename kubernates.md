Firstly we need to install kubernates on our instance you can read more about the installation here https://eksctl.io/installation/
connect to the IAM user if youre connecting outside the aws console and ensure youve attached the  necessary policy to the user. 
```
curl -O https://github.com/Junnygram/chess-container/blob/main/kubeinstall.sh
chmod +x kubeinstall.sh
./kubeinstall.sh

```
To create a `chess.yaml` manifest that deploys a Chess application,  you can follow these steps:

### 1. Create the `chess.yaml` Manifest

Below is an example of what the `chess.yaml` might look like. This YAML will deploy a Chess application using Kubernetes, similar to how you would deploy any application like NGINX.

### Example `chess.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chess-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: chess
  template:
    metadata:
      labels:
        app: chess
    spec:
      containers:
      - name: chess
        image: your-docker-image-for-chess:latest
        ports:
        - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: chess-service
spec:
  selector:
    app: chess
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: LoadBalancer
```

### 2. Apply the `chess.yaml` File

After creating the `chess.yaml` file, apply it to your Kubernetes cluster using the following command:

```bash
kubectl apply -f chess.yaml
```

### 3. Update Your Security Group (as per your screenshot)

Given that your security group currently allows traffic on port 3000, ensure that:

- Your Chess application is running on port 3000 inside the container.
- Update the service in your `chess.yaml` to expose port 3000 if that is the port your application listens on.

### Example if Chess Application Runs on Port 3000:

Update the `containerPort` and `targetPort` to 3000:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chess-deployment
spec:
  replicas: 2
  selector:
    matchLabels:
      app: chess
  template:
    metadata:
      labels:
        app: chess
    spec:
      containers:
      - name: chess
        image: your-docker-image-for-chess:latest
        ports:
        - containerPort: 3000
---
apiVersion: v1
kind: Service
metadata:
  name: chess-service
spec:
  selector:
    app: chess
  ports:
  - protocol: TCP
    port: 3000
    targetPort: 3000
  type: LoadBalancer
```

### 4. Confirm Security Group Settings

If your EC2 instance or Kubernetes Load Balancer is supposed to allow access to port 3000, make sure that the security group is correctly configured, as shown in your screenshot, to allow incoming traffic on port 3000.

### 5. Verify the Deployment

You can verify that the Chess application is running by checking the pods:

```bash
kubectl get pods
```

And by checking the service:

```bash
kubectl get svc
```

Install using Fargate
```
eksctl create cluster --name chess-cluster --region us-east-1 --fargate
```
now the cluster is created 
update 

```
aws eks update-kubeconfig --name chess-cluster --region us-east-1 --fargate
```


now lets create a fargate profile 
```
eksctl create fargateprofile \
    --cluster chess-cluster \
    --region us-east-1 \
    --name alb-sample-app \
    --namespace chess-deployment
```
