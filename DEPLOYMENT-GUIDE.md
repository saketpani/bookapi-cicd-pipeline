# Complete Deployment Guide

## Prerequisites Installation

### 1. Install Required Tools
```bash
# Install .NET 8 SDK
# Download from: https://dotnet.microsoft.com/download/dotnet/8.0

# Install Docker Desktop
# Download from: https://www.docker.com/products/docker-desktop

# Install AWS CLI
# Download from: https://aws.amazon.com/cli/

# Install Octopus CLI (optional)
choco install octopustools
```

### 2. Verify Installations
```bash
dotnet --version
docker --version
aws --version
octo --version
```

## Step-by-Step Setup

### Phase 1: AWS Infrastructure Setup

1. **Create ECR Repository**
   - AWS Console → ECR → Create repository
   - Name: `weather-api`
   - Note the repository URI

2. **Create ECS Cluster**
   - AWS Console → ECS → Create Cluster
   - Name: `weather-api-cluster`
   - Infrastructure: Fargate

3. **Create Task Definition**
   - Family: `weather-api-task`
   - Launch type: Fargate
   - CPU: 0.25 vCPU, Memory: 0.5 GB
   - Container: `weather-api`, Port: 80

4. **Create ECS Service**
   - Service name: `weather-api-service`
   - Tasks: 1
   - Public IP: Enabled

5. **Create IAM User**
   - Username: `github-actions-user`
   - Policies: ECR PowerUser, ECS FullAccess
   - Create access keys

### Phase 2: Octopus Deploy Setup

1. **Create Octopus Account**
   - Sign up at https://octopus.com/
   - Create cloud instance

2. **Configure Octopus**
   - Create project: "Weather API"
   - Create environment: "Production"
   - Add AWS account with your credentials
   - Create API key for GitHub Actions

3. **Setup Deployment Process**
   - Add "Deploy an Amazon ECS Service" step
   - Configure with your AWS details

### Phase 3: GitHub Configuration

1. **Add Repository Secrets**
   ```
   AWS_ACCESS_KEY_ID: (your IAM user access key)
   AWS_SECRET_ACCESS_KEY: (your IAM user secret key)
   OCTOPUS_URL: https://yourinstance.octopus.app
   OCTOPUS_API_KEY: (your Octopus API key)
   ```

2. **Update Configuration**
   - Replace AWS account ID in all files
   - Update ECR repository URI
   - Verify region settings

### Phase 4: Testing the Pipeline

1. **Local Testing**
   ```bash
   cd src/WeatherApi
   dotnet run
   # Test: http://localhost:5000/api/weather
   ```

2. **Docker Testing**
   ```bash
   cd src/WeatherApi
   docker build -t weather-api .
   docker run -p 8080:80 weather-api
   # Test: http://localhost:8080/api/weather
   ```

3. **Deploy Pipeline**
   ```bash
   git add .
   git commit -m "Initial deployment"
   git push origin main
   ```

## Making Changes and Redeployment

### 1. Make Code Changes
```csharp
// Example: Update WeatherController.cs
[HttpGet("health")]
public IActionResult Health()
{
    return Ok(new { 
        Status = "Healthy", 
        Timestamp = DateTime.UtcNow, 
        Version = "1.1.0"  // Updated version
    });
}
```

### 2. Commit and Push
```bash
git add .
git commit -m "Update health endpoint version"
git push origin main
```

### 3. Monitor Deployment
- Check GitHub Actions workflow
- Monitor Octopus deployment
- Verify ECS service update
- Test the updated API

## Monitoring and Troubleshooting

### 1. Check GitHub Actions
- Go to Actions tab in your repository
- Review build and deployment logs

### 2. Check Octopus Deploy
- Review deployment logs
- Check task execution details

### 3. Check AWS ECS
- Monitor service events
- Check task health
- Review CloudWatch logs

### 4. Test API Endpoints
```bash
# Get public IP from ECS task
curl http://YOUR-PUBLIC-IP/api/weather
curl http://YOUR-PUBLIC-IP/api/weather/health
```

## Common Issues and Solutions

### 1. ECR Push Failed
- Verify AWS credentials
- Check ECR repository exists
- Ensure proper IAM permissions

### 2. ECS Deployment Failed
- Check task definition is valid
- Verify security group allows traffic
- Check container logs in CloudWatch

### 3. Octopus Deployment Failed
- Verify AWS account configuration
- Check variable values
- Review deployment process steps

### 4. API Not Accessible
- Verify ECS service is running
- Check security group rules
- Ensure public IP is assigned

## Security Best Practices

1. **Use least privilege IAM policies**
2. **Store secrets securely in GitHub Secrets**
3. **Use private ECR repositories**
4. **Configure proper security groups**
5. **Enable CloudWatch logging**
6. **Use HTTPS in production**

## Cost Optimization

1. **Use Fargate Spot for non-production**
2. **Right-size CPU and memory**
3. **Monitor CloudWatch costs**
4. **Use lifecycle policies for ECR**
5. **Scale down during off-hours**

## Next Steps

1. **Add automated tests**
2. **Implement blue-green deployments**
3. **Add monitoring and alerting**
4. **Setup multiple environments**
5. **Add database integration**