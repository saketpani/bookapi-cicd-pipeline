## Push Docker Image to ECR

=======================
Authentication: Docker login to your private ECR

Tagging: Rename local image to match ECR URI format

Upload: Push ~200MB image to AWS

🔧 AWS CLI Configuration Persistence
AWS CLI configurations are stored in files located in the user's home directory.
Windows: C:\Users\{username}\.aws\
├── credentials (Access keys)
└── config (Region, output format)

# See current configuration

aws configure list

# See which region you're using

aws configure get region

🤔 What is ECS Cluster?
Logical grouping of compute resources

Fargate: Serverless (AWS manages servers)

Scalable: Can run multiple services/tasks

🏷️ What is ARN?
ARN = Amazon Resource Name - AWS's unique identifier system

ARN Structure:

arn:aws:service:region:account-id:resource-type/resource-name

arn:aws:ecs:us-east-1:594102048007:cluster/book-api-cluster
│ │ │ │ │ │ │
│ │ │ │ │ │ └─ Resource name
│ │ │ │ │ └─ Resource type  
│ │ │ │ └─ Your AWS Account ID
│ │ │ └─ Region (us-east-1)
│ │ └─ Service (ECS)
│ └─ Cloud provider (AWS)
└─ Amazon Resource Name

## Task Definition

A Task Definition is like a "recipe" that tells ECS how to run your container.

### 🎯 Task Definition vs Kubernetes YAML

**ECS Task Definition** ≈ **Kubernetes Deployment YAML**

#### Kubernetes YAML:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: book-api
spec:
  replicas: 1
  selector:
    matchLabels:
      app: book-api
  template:
    metadata:
      labels:
        app: book-api
    spec:
      containers:
        - name: book-api
          image: book-api:latest
          ports:
            - containerPort: 80
          resources:
            requests:
              memory: "512Mi"
              cpu: "250m"
```

#### ECS Task Definition (JSON):

```json
{
  "family": "book-api-task",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "containerDefinitions": [
    {
      "name": "book-api",
      "image": "594102048007.dkr.ecr.us-east-1.amazonaws.com/book-api:latest",
      "portMappings": [
        {
          "containerPort": 80,
          "protocol": "tcp"
        }
      ],
      "essential": true
    }
  ]
}
```

#### Key Similarities:

- **Container image** specification
- **Resource limits** (CPU/Memory)
- **Port mappings**
- **Container configuration**
- **Declarative approach**

#### Key Differences:

- **Kubernetes**: YAML format, kubectl apply
- **ECS**: JSON format, AWS Console/CLI
- **Kubernetes**: Pods, Deployments, Services
- **ECS**: Tasks, Services, Clusters

Task Definition = Deployment YAML

ECS Service = Kubernetes Service

ECS Cluster = Kubernetes Cluster

Fargate = Managed node pools

## AWS IAM Identity & Access Management

### 🔐 IAM Architecture Hierarchy:
```
AWS Account
├── IAM User (Identity - WHO)
│   ├── Permissions (Policies - WHAT can be done)
│   └── Credentials (Access Methods - HOW to authenticate)
│       ├── Console Password (for humans)
│       └── Access Keys (for programs)
```

### 🎯 Key Concepts:

#### Identity vs Credentials:
- **IAM User** = WHO (identity, like a person's name)
- **Access Keys** = HOW (credentials, like a person's ID card)

#### Real World Analogy:
```
Real World:
Person (John) → Has ID Card → Uses ID to access building

AWS World:
IAM User (github-actions-bookapi) → Has Access Keys → Uses keys to access AWS APIs
```

#### Why Access Keys Need a User:
- **Permissions are attached to Users**, not keys
- **Keys are just authentication method**
- **User defines WHAT can be done**
- **Keys prove WHO is doing it**

### 📋 Authentication Flow:
**What Happens When GitHub Actions Calls AWS:**
```
1. GitHub Actions → Uses Access Key + Secret
2. AWS → "These keys belong to user 'github-actions-bookapi'"
3. AWS → "What permissions does this user have?"
4. AWS → Checks attached policies (ECR, ECS permissions)
5. AWS → Allows/Denies the action
```

### 🎯 Two Types of AWS Access:
| **Access Type** | **For** | **Credentials** | **Use Case** |
|-----------------|---------|-----------------|-------------|
| **Console Access** | Humans | Username + Password | Web UI |
| **Programmatic Access** | Programs | Access Key + Secret | APIs, CLI, GitHub Actions |

### 💡 Key Insight:
**User = Bank Account (has permissions)**  
**Access Keys = ATM Card (way to access the account)**  
**You need both** - card alone is useless without an account!

## AWS CLI Profiles Management

### 🔧 Profile System:
```
~/.aws/
├── credentials
│   ├── [default]          ← Your original config
│   └── [github-actions-test] ← New profile
└── config
    ├── [default]          ← Your original settings
    └── [profile github-actions-test] ← New profile settings
```

### 🎯 Profile Commands:
```bash
# Configure default profile
aws configure

# Configure named profile (doesn't override default)
aws configure --profile github-actions-test

# List all profiles
aws configure list-profiles

# Use default profile
aws ecs list-clusters

# Use specific profile
aws ecs list-clusters --profile github-actions-test
```

### 💡 Key Benefits:
- **Multiple AWS accounts** can be managed
- **Different permissions** per profile
- **No override** of existing configurations
- **Easy switching** between environments

### 🎯 Common Use Cases:
- **Default**: Personal/main AWS account
- **Work**: Company AWS account
- **CI/CD**: Service account for automation
- **Testing**: Sandbox environment

## GitHub Secrets vs AWS Secrets

### 🔐 Different Perspectives on "Secrets":

#### GitHub's Perspective:
**ALL values in GitHub Secrets are "secrets"** because:
- **Sensitive configuration** that shouldn't be in code
- **Encrypted and hidden** from logs
- **Control access** to external systems

#### AWS Perspective:
| **Value** | **AWS Classification** | **Actual Sensitivity** |
|-----------|------------------------|------------------------|
| `AWS_SECRET_ACCESS_KEY` | True secret | 🔒 Password-like |
| `AWS_ACCESS_KEY_ID` | Public identifier | 👤 Username-like |
| `AWS_REGION` | Configuration | 📍 Public info |
| `ECR_REPOSITORY` | Configuration | 📦 Public info |

### 🎯 Secret Names - Custom vs Convention:

#### Are Secret Names Built-in?
**NO!** You can use ANY names:
```yaml
# Standard convention (recommended):
AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}

# Custom names (also works):
AMAZON_SECRET_ACCESS_KEY: ${{ secrets.AMAZON_SECRET_ACCESS_KEY }}
MY_AWS_KEY: ${{ secrets.MY_AWS_KEY }}
COMPANY_ECR_REPO: ${{ secrets.COMPANY_ECR_REPO }}
```

#### Why Use Standard Names?
- **AWS CLI tools** expect standard environment variables
- **GitHub Actions AWS plugins** use these by default
- **Team consistency** - everyone understands them
- **Documentation alignment** - matches AWS docs

### 💡 Key Insights:
- **GitHub Secrets = Secure Storage** (everything encrypted)
- **Secret Names = Your Choice** (no built-in requirements)
- **Only `AWS_SECRET_ACCESS_KEY` is truly "secret"**
- **Others are just configuration stored securely**

---
