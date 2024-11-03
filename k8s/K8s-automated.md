### **Step 1: Create a Workload Identity Pool**

We created a "Workload Identity Pool" using Google Cloud's Identity and Access Management (IAM). This pool allows our application (in this case, GitHub Actions) to securely authenticate with Google Cloud services. Think of it as a "gateway" that verifies if our app is who it says it is before letting it access Google resources.

```bash
gcloud iam workload-identity-pools create "k8s-pool-v1" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --display-name="k8s Pool v1"
```

### **Step 2: Create an OIDC Identity Provider for GitHub**

OpenID Connect (OIDC) is a way to securely exchange identity information between our GitHub Actions workflow and Google Cloud. By setting up an "OIDC Identity Provider," we let Google Cloud trust and understand authentication requests from GitHub. This step ensures that our app's actions are authenticated and authorized to perform operations in our Google Cloud project.

```bash
gcloud iam workload-identity-pools providers create-oidc "k8s-provider" \
  --project="${PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="k8s-pool-v1" \
  --display-name="k8s provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.aud=assertion.aud" \
  --issuer-uri="https://token.actions.githubusercontent.com"
```

### **Step 3: Create a Service Account with Permissions**

A service account in Google Cloud is like a user account, but for applications instead of people. We created a service account and gave it special permissions (roles) to perform tasks like:

Managing compute resources (e.g., virtual machines and clusters)
Handling Kubernetes operations
Accessing and modifying storage
These roles ensure our app can manage infrastructure and deploy updates to our Kubernetes cluster.

```bash
gcloud iam service-accounts create "tf-gke-test" \
  --project="${PROJECT_ID}" \
  --display-name="Terraform GKE Service Account"
```

### **Assign Roles to the Service Account**

```bash
gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:tf-gke-test@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/compute.admin"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:tf-gke-test@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/container.admin"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:tf-gke-test@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/container.clusterAdmin"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:tf-gke-test@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountTokenCreator"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:tf-gke-test@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding "${PROJECT_ID}" \
  --member="serviceAccount:tf-gke-test@${PROJECT_ID}.iam.gserviceaccount.com" \
  --role="roles/storage.admin"
```

### **Step 4: Create a GCS Bucket for Terraform State**

Terraform uses a "state file" to keep track of the infrastructure it manages. We store this state file in a Google Cloud Storage (GCS) bucket so that our team can share and maintain the current infrastructure state. It helps avoid errors and ensures consistency when deploying or updating resources.

```bash
gsutil mb -p "${PROJECT_ID}" -l "us-central1" "gs://${TF_STATE_BUCKET_NAME}"
```

### **Step 5: Get Your GCP Project Number**

The project number is a unique identifier for our Google Cloud project. We need it for configuration purposes, like linking our project to authentication settings.

```bash
gcloud projects describe "${PROJECT_ID}" --format="value(projectNumber)"
```

### **Step 6: Add Secrets to GitHub Repository**

- **GCP_PROJECT_ID**
- **GCP_TF_STATE_BUCKET**

### **GitHub Actions Workflow for Deploying to GKE Using Terraform**

This configuration ensures your GitHub Actions workflow is ready for deploying your app to GKE using Terraform.
