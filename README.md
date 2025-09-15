# 🚀 Declarative Cloud Provisioning of NGINX Web Server Using Terraform and Azure Resource Modules

## Project Overview

**Automated provisioning** of Linux-based web server on **Microsoft Azure** using **Terraform**, featuring **secure network configuration** and **remote-exec deployment of Nginx**. This project demonstrates **infrastructure-as-code principles, streamlines cloud-native service delivery, and reinforces scalable deployment workflows**.


## 📦 Provisioned Components

### 1. Resource Group
- **Name**: `laredo-01-rg`
- **Location**: `UK South`

### 2. Virtual Network & Subnet
- **VNet**: `laredo-vnet` (`10.0.0.0/16`)
- **Subnet**: `laredo-subnet-1` (`10.0.1.0/24`)

### 3. Network Security Group (NSG)
- **Name**: `laredo-nsg`
- **Inbound Rules**:
  - `Allow-SSH` on port `22`
  - `Allow-HTTP` on port `80`

### 4. Public IP
- **Name**: `laredo-public-ip`
- **Type**: Static, Standard SKU

### 5. Network Interface
- **Name**: `laredo-nic`
- **Attached to**: Subnet and Public IP

### 6. NSG Association
- Associates `laredo-nic` with `laredo-nsg` to enforce security rules.


## 🖥️ Virtual Machine Configuration

### VM Details
- **Name**: `laredo-vm`
- **Size**: "Standard_B2s"
- **OS**: Ubuntu Server `18.04-LTS`
- **Disk**: 30GB, `Standard_LRS`
- **Admin Credentials**:
  - Username: `laredo`
  - Password: `Laredo@ssword!`

### Networking
- **NIC**: `laredo-nic`
- **Public IP**: Assigned for external access



## ⚙️ Remote Provisioning

### Provisioner: `remote-exec`
Installs and starts **Nginx** on the VM immediately after provisioning.

```bash
sudo apt-get install -y nginx
sudo systemctl start nginx
```

### SSH Connection
- **User**: `laredo`
- **Password**: `Laredo@ssword!`
- **Host**: Public IP of the VM



## ✅ Usage Instructions

### 1. Initialize Terraform
```bash
terraform init
```

### 2. Review and Apply Plan
```bash
terraform plan
terraform apply
```

### 3. Access the VM
- **SSH**: `ssh laredo@<public-ip>`
- **Web**: Visit `http://<public-ip>` to verify Nginx is running

---

## 🔐 Security Notes

- Password authentication is enabled for simplicity. For production, consider using **SSH key pairs** and **vaulted secrets**.
- NSG rules expose ports `22` and `80`—ensure these are scoped appropriately in production environments.

---

## 📚 Learning Outcomes

This configuration demonstrates:
- Modular provisioning of Azure infrastructure  
- Declarative security and networking  
- Automated service deployment via remote-exec  
- Infrastructure-as-code best practices for cloud-native delivery

---

## 🧠 Next Steps

- Replace `remote-exec` with **cloud-init** or **Ansible** for idempotent provisioning  
- Integrate with **CI/CD pipelines** for automated deployment  
- Add **monitoring agents** (e.g., Prometheus Node Exporter) for observability  
- Scaffold into a **smart home automation pipeline** or **healthcare IT module**


## 📎 License

This project is intended for educational and demonstrative use. Adapt freely for curriculum artefacts, sector-facing documentation, or portfolio entries.


## Notes

Authenticate with Azure using the **Azure CLI**

### 🛠️ How to Fix It

#### ✅ **Option 1: Install Azure CLI**
If you're using local development or a CI runner that supports CLI-based auth:

1. **Install Azure CLI**:
   - On Windows:  
     [Download from Microsoft Docs](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows)
   - On macOS/Linux:  
     Use `brew install azure-cli` or follow [Linux install guide](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux)

2. **Login to Azure**:
   ```bash
   az login
   ```

3. **Verify it's in your PATH**:
   ```bash
   az version
   ```
4. **Check Installation to Retrieve SubscriptionID**
  
 ```bash
   az account show --query id --output tsv

or 
  az account list --output table


   ```


#### ✅ **Option 2: Use Service Principal Authentication (Recommended for CI/CD)**

The use of  **environment variables** for authentication when running Terraform in automation such as GitHub Actions and Azure DevOps is best practices instead of relying on Azure CLI.

The folloing MUST be added the environment:

```bash
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
export ARM_TENANT_ID="your-tenant-id"
```

