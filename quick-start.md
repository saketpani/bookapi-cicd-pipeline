# Quick Start Guide

## 🚀 Get Started in 15 Minutes

### 1. Prerequisites Check
```bash
dotnet --version  # Should be 8.0+
docker --version  # Should be 20.0+
aws --version     # Should be 2.0+
```

### 2. Test Locally
```bash
cd src/BookApi
dotnet run
```
Visit: http://localhost:5000/api/book

### 3. Test Docker Build
```bash
cd src/BookApi
docker build -t book-api .
docker run -p 9090:80 book-api
```
Visit: http://localhost:9090/api/book

### 4. AWS Setup (5 minutes)
1. Create ECR repository: `book-api`
2. Create ECS cluster: `book-api-cluster`
3. Create IAM user with ECR/ECS permissions
4. Note your AWS Account ID

### 5. Octopus Setup (5 minutes)
1. Sign up at https://octopus.com/
2. Create project: "Book API"
3. Add AWS account
4. Create API key

### 6. GitHub Setup (2 minutes)
Add these secrets to your repository:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `OCTOPUS_URL`
- `OCTOPUS_API_KEY`

### 7. Update Configuration (2 minutes)
Replace `123456789012` with your AWS Account ID in:
- `octopus/variables.json`
- `aws-setup/setup-instructions.md`

### 8. Deploy! (1 minute)
```bash
git add .
git commit -m "Initial deployment"
git push origin main
```

### 9. Test Production
```powershell
# Get your ECS task public IP from AWS Console
.\test-api.ps1 -ApiUrl "http://YOUR-PUBLIC-IP"
```

## 🔄 Make Changes and Redeploy

1. Edit `src/BookApi/Controllers/BookController.cs`
2. Change version in health endpoint
3. Commit and push
4. Watch the magic happen! ✨

## 📊 Monitor Your Deployment

- **GitHub Actions**: Check workflow status
- **Octopus Deploy**: Monitor deployment progress  
- **AWS ECS**: Verify service health
- **API**: Test endpoints

## 🆘 Need Help?

Check the detailed guides:
- `DEPLOYMENT-GUIDE.md` - Complete setup instructions
- `aws-setup/setup-instructions.md` - AWS configuration
- `octopus/octopus-setup.md` - Octopus Deploy setup

## 🎯 What You've Built

✅ .NET 8 Book API  
✅ Docker containerization  
✅ GitHub Actions CI/CD  
✅ Amazon ECR registry  
✅ Amazon ECS with Fargate  
✅ Octopus Deploy orchestration  
✅ Automated deployments  

**Congratulations! You now have a production-ready CI/CD pipeline! 🎉**