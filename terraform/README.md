# Deploy an Avalanche Full Node to GKE Using Cloud Build and Terraform

This is a quick example on how to use cloud build and terraform to deploy an Avalanche testnet fullnode to GKE.

This is a development example only and should not be used for production.  


# Install a VM Workstation

 * Create a small VM workstation to run these commands. A cloud shell could be used, but a VM workstation would be better to store files specifically for this deployment.

 * The workstation VM should have Ubuntu 20.04 OS installed.

 * Created an avalanche user to run commands under

```
sudo useradd -m avalanche
sudo usermod -aG sudo avalanche
sudo usermod -aG google-sudoers avalanche
sudo su avalanche
bash
cd ~
```

# Install Pre-Requisites

Install following on your workstation

   * Terraform 1.1.7: https://www.terraform.io/downloads.html
   * Google Cloud CLI with kubectl: https://cloud.google.com/sdk/docs/install-sdk#deb
   * Install gcloud components `sudo apt-get update && sudo apt-get install google-cloud-cli kubectl google-cloud-sdk-gke-gcloud-auth-plugin`


# Deploy Everything with Cloud Build

## Set Permissions

 * Apply the following roles in IAM to the cloudbuild service account.

 * In IAM screen, check the checkbox "Include Google-provided role grants"

 * Look for the account "<project-id>@cloudbuild.gserviceaccount.com".  Apply the following roles

  - Cloud Build Service Account
  - Compute Network Admin
  - Project IAM Admin
  - Kubernetes Engine Cluster Admin
  - Kubernetes Engine Node Service
  - Kubernetes Engine Developer

Add role:
```
gcloud projects add-iam-policy-binding ${GCP_PROJECT_ID} \
    --member=serviceAccount:${GCP_SVC_ACC} \
    --role=roles/container.admin
```

Using the UI:
`Grant "{PROJECT_ID}@cloudbuild.gserviceaccount.com" access to "{PROJECT_ID}-compute@developer.gserviceaccount.com" and "avalanche-default-gke@gcda-dev.iam.gserviceaccount.com" using the "service account user" role`



## Run deployment script
To create the GCP infrastructure and deploy the Avalanche fullnode to the cluster, run the following script.  This will use GCP's Cloud Build to deploy everything.

```
./submitBuild.sh
```

## To Destroy Everything with Cloud Build

To destroy the GCP infrastructure and the Avalanche fullnode, run the following script.  This will use GCP's Cloud Build to destroy everything.

```
./submitDestroy.sh
```


# Setup Just Infrastructure with Terraform


1. Create a storage bucket for storing the Terraform state on Google Cloud Storage.  Use the GCP UI or Google Cloud Storage command to create the bucket.  The name of the bucket must be unique.  See the Google Cloud Storage documentation here: https://cloud.google.com/storage/docs/creating-buckets#prereq-cli

  ```
  gsutil mb gs://$BUCKET_NAME
  # for example
  gsutil mb gs://<project-name>-ava-tf
  ```


2. Modify `main.tf` file to configure Terraform, and update the BUCKET_NAME. Example content for `main.tf`:
  ```
  terraform {
    backend "gcs" {
      bucket = "BUCKET_NAME" # bucket name created in step 1
      prefix = "state/validator"
    }
  }
  ```

3. Update `variables.tf` with project id, region and zone


4. Initialize Terraform in the same directory of your `main.tf` file
  ```
  $ terraform init
  ```
This will download all the Terraform dependencies for you, in the `.terraform` folder in your current working directory.

5. Create a new Terraform workspace to isolate your environments:
  ```
  terraform workspace new $WORKSPACE
  # This command will list all workspaces
  terraform workspace list
  ```

6. Apply the configuration.

  ```
  $ terraform apply
  ```

  This might take a while to finish (10 - 20 minutes), Terraform will create all the resources on your cloud account. 

7. Once Terraform apply finishes, you can check if these resources are created:

    GKE
    * avalanche-cluster

To deploy the node to GKE, follow the [Deploy to GKE](gke/README.md) instructions.


## Remove Infrastructure with Terraform

Run the following command to remove the infrastructure

```
terraform destroy
```


