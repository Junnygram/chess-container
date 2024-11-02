# Chess App Deployment on Google Kubernetes Engine (GKE)

This guide walks you through deploying the `chess-app` on Google Kubernetes Engine (GKE) using a standard Kubernetes cluster. It covers creating a project, setting up the cluster, building and pushing the Docker image, and deploying with a load-balanced service.

## Prerequisites

- **Google Cloud Platform (GCP) account**: Set up and enable billing.
- **Google Cloud SDK** installed.
- **kubectl** and **gke-gcloud-auth-plugin** installed.

## Deployment Steps

### 1. Enable Kubernetes Engine API

Go to the **Google Cloud Console** and enable the **Kubernetes Engine API**.

![SEnable Kubernetes API](https://github.com/user-attachments/assets/cee1465e-61e5-4124-aefe-62eaedfeb3bf)

### 2. Create a New Project and Cluster

1. **Create Project**:
   - Go to **Google Cloud Console** and create a project (e.g., `kubernetes-440515`).
     
2. **Create Cluster**:
   - In the Kubernetes Engine section, create a new cluster.
   - Choose **Standard Cluster** and follow the setup guide (e.g., "My First Cluster").

   ![Screenshot 2024-11-02 at 16 13 52](https://github.com/user-attachments/assets/984f1d9f-172e-4963-800c-f0d2edba658f)

![Screenshot 2024-11-02 at 16 15 24](https://github.com/user-attachments/assets/db228d4d-c9b8-47e8-960c-78a382ed10be)

![Screenshot 2024-11-02 at 16 16 13](https://github.com/user-attachments/assets/2ef8058a-eaaf-43a3-9840-926c175134bb)

3. cli authentication
    ```bash
   gcloud auth login
   ```

### 3. Build and Push Docker Image

1. **Build the Image**:
   ```bash
   docker build -t us.gcr.io/kubernetes-440515/chess-app:v1 .
   ```
2. **Push the Image** to Google Container Registry (GCR):
   ```bash
   docker push us.gcr.io/kubernetes-440515/chess-app:v1
   ```
![Screenshot 2024-11-02 at 17 13 58](https://github.com/user-attachments/assets/d3907ec8-32d9-4d1e-92ae-fbb22249eb87)

![Screenshot 2024-11-02 at 17 27 11](https://github.com/user-attachments/assets/61a69644-54b5-4a4b-8668-0ab3c45bd95b)

Example output:

![Service Status](https://github.com/user-attachments/assets/2b8b6019-761d-459b-a7c5-06b1173c2151)


### 4. Install the GKE Auth Plugin and Authenticate

1. **Install the GKE Auth Plugin**:
   ```bash
   gcloud components install gke-gcloud-auth-plugin
   ```
2. **Get Cluster Credentials**:
   ```bash
   gcloud container clusters get-credentials my-first-cluster-1 --zone us-central1-c --project kubernetes-440515
   ```
![Get Cluster Credentials](https://github.com/user-attachments/assets/9bcc38e7-c2de-45e7-9156-1fba40ca2ff5)

### 5. Verify Cluster Information

1. **Check Cluster Info**:
   ```bash
   kubectl cluster-info
   ```

### 6. Deploy the Application

Create a `deployment.yaml` file with the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chess-app
  labels:
    type: backend
    app: nodeapp
spec:
  replicas: 1
  selector:
    matchLabels:
      type: backend
      app: nodeapp
  template:
    metadata:
      name: reactapppod
      labels:
        type: backend
        app: nodeapp
    spec:
      containers:
        - name: chess-container
          image: us.gcr.io/kubernetes-440515/chess-app:v1
          ports:
            - containerPort: 80
```

1. **Apply the Deployment Configuration**:
   ```bash
   kubectl apply -f deployment.yaml
   ```
2. **Verify Deployment**:
   ```bash
   kubectl get deploy
   ```

![Deploy Application](https://github.com/user-attachments/assets/914c7730-6375-451f-9c2b-9c683ae71774)

### 7. Expose the Service with a Load Balancer

Create a `service.yaml` file with the following content:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: react-app-load-balancer-service
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 80
  selector:
    type: backend
    app: nodeapp
```
In Kubernetes, the `Service` selector must match the labels in the `Deployment` template, and the `targetPort` in the `Service` must align with the `containerPort` in the `Deployment`. While names, replica counts, and container configurations can vary, these critical matches ensure that traffic is correctly routed to the intended pods. This setup allows for flexibility in managing resources without compromising functionality.

1. **Apply the Service Configuration**:
   ```bash
   kubectl apply -f service.yaml
   ```
2. **Verify Service Status**:
   ```bash
   kubectl get svc
   ```


### 8. Access the Application

Once the LoadBalancer service is created, note the external IP. You can access the app using this IP on port 80.

Example:
```
URL: http://34.42.72.202
```
![Screenshot 2024-11-02 at 18 34 59](https://github.com/user-attachments/assets/5789760b-a981-4720-b34a-845b221fb3c0)

![Access Application](https://github.com/user-attachments/assets/5b4fb954-479c-46cd-bd59-3b3ca4e80ceb)

### 9. Deleting our cluster 
```bash
   gcloud container clusters delete my-first-cluster-1 --zone us-central1-c --project kubernetes-440515
```

---

