# 🌐 GCP Public Web Server Deployment

Loadbalancer IP: http://35.244.152.23/

This project deploys a publicly accessible, secure web server on Google Cloud Platform using **Terraform** and optionally **Ansible**. The server is protected by a global HTTP Load Balancer and serves a static HTML page, with optional integration with a GCS bucket for content.

---

## 🏗️ Architecture Diagram


![alt text](<Blank diagram.jpeg>)


  User --> LB
  LB --> VM
  VM --> GCS
  VM --> VPC
  GCS -->|Read-only Access| VM


**Prerequisites**

Terraform ≥ 1.3

Google Cloud SDK (gcloud)

GCP Project with billing enabled

Startup Script

(Optional) Ansible for remote provisioning

Service account JSON key (or use Secret Manager)

**Authenticate**

export GOOGLE_APPLICATION_CREDENTIALS="/path/to/terraform-sa-key.json"


**Deploy with Terraform**

cd terraform (compute and network folders)

terraform init

terraform plan

terraform apply

Outputs:

Load Balancer IP

GCS bucket name

Optional: VM external IP


**Startup Script**

apt-get update
apt-get install -y nginx curl

gcloud storage cp gs://**bucketname**/index.html /var/www/html/index.html

systemctl restart nginx


**Constraints and Design Decisions**

**Managing the terraform variables:** I am used to using pipeline-ci-vars as they are more secure. I used terraform.tfvars to pass the variables. Recommend using pipelines.

**Limiting permissions:** I needed to test permissions out to know which one was least permissive but allowed the required permissions


**FedRAMP Moderate system**
Use assured workloads to enforce fedramp compliance.

Deploy workloads only within ATO boundries.

Configure workloads in accordance with the shared responsibility model, Customer Responsibility Matrix, in-scope Google Cloud services, and FedRAMP guidelines.
