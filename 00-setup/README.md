# Azure Terraform Setup In Ubuntu

This guide helps you set up Azure CLI, Terraform, log in to Azure, create a Service Principal, and export environment variables for Terraform usage.

## 1. Install and Verify Azure CLI

Run the following command to install Azure CLI and verify the installation:

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash && az version
```

## 2. Install and Verify Terraform

Run the following commands to install Terraform and verify the installation:

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt-get update && sudo apt-get install terraform
terraform version
```

## 3. Log in to Azure

Run the following command and follow the instructions to log in:

```bash
az login
```

## 4. Create a Service Principal

Run the following command to create a Service Principal (replace `<NAME>` with your desired name):

```bash
az ad sp create-for-rbac --name <NAME> --role Contributor --scopes /subscriptions/<SUBSCRIPTION_ID>
```

This will output JSON with `appId`, `password`, and `tenant`.

## 5. Export Terraform Environment Variables

Export the following environment variables using the values from the Service Principal output:

```bash
export ARM_CLIENT_ID=<appId>
export ARM_CLIENT_SECRET=<password>
export ARM_SUBSCRIPTION_ID=<subscriptionId>
export ARM_TENANT_ID=<tenant>
```