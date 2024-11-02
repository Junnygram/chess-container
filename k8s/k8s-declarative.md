
# Chess App Deployment on Kubernetes

This repository contains Kubernetes configuration files for deploying a Node.js backend service, `chess-app`, on a Kubernetes cluster. It includes instructions for setting up Google Cloud resources, pushing the Docker image to Google Artifact Registry, and deploying the app using Kubernetes.

---

## Prerequisites

### Tools Needed
1. **Google Cloud SDK (gcloud)**: For interacting with Google Cloud from your terminal.
2. **Docker**: To build and push container images.
3. **kubectl**: Command-line tool to manage Kubernetes clusters.

### Project Setup
1. **Google Cloud Project**: Set up a Google Cloud Project on [Google Cloud Console](https://console.cloud.google.com).
2. **Artifact Registry**: Create an Artifact Registry for storing Docker images.

---

## Step-by-Step Guide

### Step 1: Install Google Cloud SDK and Authenticate

1. **Install Google Cloud SDK**:
   - Follow the installation instructions for your operating system on the [Google Cloud SDK Installation page](https://cloud.google.com/sdk/docs/install).

2. **Initialize gcloud**:
   - After installing, open your terminal and initialize the gcloud CLI:
     ```bash
     gcloud init
     ```
   - Follow the prompts to log in to your Google account and select your project.

3. **Authenticate Docker with Google Cloud**:
   - Configure Docker to use Google Cloud as a credential helper, allowing it to interact with Google Artifact Registry:
     ```bash
     gcloud auth configure-docker us-docker.pkg.dev
     ```

---

### Step 2: Set Up Google Cloud Resources

1. **Create a Google Cloud Project**: 
   - Go to the [Google Cloud Console](https://console.cloud.google.com/projectcreate) and create a new project.
   - Make a note of the **Project ID**.

2. **Enable Required APIs**:
   - In your terminal, enable the necessary APIs for your project:
     ```bash
     gcloud services enable compute.googleapis.com container.googleapis.com artifactregistry.googleapis.com
     ```

3. **Set Up Artifact Registry**:
   - Navigate to **Artifact Registry** in Google Cloud Console.
   - Create a new repository:
     - **Repository Name**: `chess-app`
     - **Region**: Choose a preferred region.
     - **Format**: Docker
   - Once created, make a note of the repository URL (e.g., `us-docker.pkg.dev/[PROJECT_ID]/chess-app`).

   ![Creating Artifact Registry](https://github.com/user-attachments/assets/938d4cfc-f16a-4317-b2c1-4d75ccebcc22)

---

### Step 3: Build and Push Docker Image to Artifact Registry

1. **Build the Docker Image**:
   - In the directory where your Dockerfile is located, build the Docker image:
     ```bash
     docker build -t us-docker.pkg.dev/[PROJECT_ID]/chess-app/chess-app:v1 .
     ```

2. **Push the Image to Artifact Registry**:
   - Push the Docker image to your Artifact Registry:
     ```bash
     docker push us-docker.pkg.dev/[PROJECT_ID]/chess-app/chess-app:v1
     ```

   ![Building Docker Image](https://github.com/user-attachments/assets/867b5eae-98ad-4d2b-9dce-20c419225058)
   ![Pushing Docker Image](https://github.com/user-attachments/assets/e6d892cf-67e8-4532-9fcc-8b881758d211)

---

### Step 4: Deploy to Kubernetes

1. **Set Up Kubernetes Cluster**:
   - Create a Kubernetes cluster using GKE:
     ```bash
     gcloud container clusters create chess-app-cluster --zone [ZONE] --num-nodes 1
     ```
   - Connect `kubectl` to your cluster:
     ```bash
     gcloud container clusters get-credentials chess-app-cluster --zone [ZONE]
     ```

   ![GKE Setup](https://github.com/user-attachments/assets/adb392c5-a9b7-4337-a75c-e041bb95faec)

2. **Apply Kubernetes Configurations**:
   - **`deployment.yaml`**: Contains the deployment specification for `chess-app`.
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
               image: us-docker.pkg.dev/[PROJECT_ID]/chess-app/chess-app:v1
               ports:
                 - containerPort: 80
     ```
   - **`service.yaml`**: Exposes the application through a LoadBalancer service.
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

   - Deploy both configurations:
     ```bash
     kubectl apply -f deployment.yaml
     kubectl apply -f service.yaml
     ```

   ![Service Deployment](https://github.com/user-attachments/assets/914c7730-6375-451f-9c2b-9c683ae71774)

3. **Verify Deployment and Service**:
   - Check the deployment status:
     ```bash
     kubectl get deployments
     ```
   - Retrieve the external IP of the service to access the app:
     ```bash
     kubectl get services react-app-load-balancer-service
     ```

---

## Accessing the Application

Once the service is up, access the application using the external IP provided by the LoadBalancer service. It may take a few minutes for the IP to be assigned.

---



## Troubleshooting

- **Image Pull Errors**: Ensure that the correct repository path and image version are used in `deployment.yaml`.
- **Service IP Not Assigned**: LoadBalancer services may take some time to provision an external IP.

Use `kubectl describe` on pods and services for detailed error messages if issues arise.

---

## License

This project is licensed under the [MIT License](LICENSE).






![Screenshot 2024-11-02 at 18 34 59](https://github.com/user-attachments/assets/938d4cfc-f16a-4317-b2c1-4d75ccebcc22)
![Screenshot 2024-11-02 at 17 27 25](https://github.com/user-attachments/assets/e6d892cf-67e8-4532-9fcc-8b881758d211)
![Screenshot 2024-11-02 at 17 27 11](https://github.com/user-attachments/assets/867b5eae-98ad-4d2b-9dce-20c419225058)
![Screenshot 2024-11-02 at 17 13 58](https://github.com/user-attachments/assets/914c7730-6375-451f-9c2b-9c683ae71774)
![Screenshot 2024-11-02 at 17 13 21](https://github.com/user-attachments/assets/28e1924d-9894-4525-9efe-425ac96c290b)
![Screenshot 2024-11-02 at 17 11 32](https://github.com/user-attachments/assets/2b8b6019-761d-459b-a7c5-06b1173c2151)
![Screenshot 2024-11-02 at 16 34 26](https://github.com/user-attachments/assets/adb392c5-a9b7-4337-a75c-e041bb95faec)
![Screenshot 2024-11-02 at 16 33 44](https://github.com/user-attachments/assets/1151ba59-028c-4a8e-8501-c2b895b8287e)
![Screenshot 2024-11-02 at 16 25 56](https://github.com/user-attachments/assets/c93a5377-9c94-439f-abb7-41d271bc9f96)
![Screenshot 2024-11-02 at 16 16 13](https://github.com/user-attachments/assets/fe5df57f-d789-4e8d-8aff-ebfe439aab90)
![Screenshot 2024-11-02 at 16 15 24](https://github.com/user-attachments/assets/2ebdf5ee-37b0-4701-b202-6e0360a20fe9)
![Screenshot 2024-11-02 at 16 13 52](https://github.com/user-attachments/assets/f2c17cf6-cbdb-4a7d-af2d-3a7391408ef4)
![Screenshot 2024-11-02 at 16 11 58](https://github.com/user-attachments/assets/b9b40ef2-28a4-4557-8a68-c75ff286548b)
![IMG_3E78A83F8D34-1](https://github.com/user-attachments/assets/5b4fb954-479c-46cd-bd59-3b3ca4e80ceb)
