# 🚀 Migrate an Application from Local Machine to Kubernetes

This repository provides a step-by-step guide to migrate an application from a **local environment** to **Kubernetes** on AWS **EKS**.

## 📌 Prerequisites
Before starting, ensure you have the following installed:
- [Docker](https://www.docker.com/get-started)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [eksctl](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)
- AWS CLI configured with the correct IAM permissions
- A GitHub account for storing source code

## 📌 Steps to Migrate

### 1️⃣ Run the Application Locally
Start with a simple Python **Flask** application.

Install dependencies:
```sh
pip install flask
```

Create `server.py`:
```python
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Hello, Kubernetes!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

Run the application:
```sh
python server.py
```

Test it on `http://localhost:5000`.

### 2️⃣ Containerize the Application
Create a `Dockerfile`:
```dockerfile
FROM python:3.8
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY . .
CMD ["python", "server.py"]
```

Build the Docker image:
```sh
docker build -t flask-app .
```

Run the container locally:
```sh
docker run -d -p 5000:5000 flask-app
```

Verify by accessing `http://localhost:5000`.

### 3️⃣ Push the Image to Docker Hub / ECR
Tag the image:
```sh
docker tag flask-app <your-dockerhub-username>/flask-app:latest
```

Push the image:
```sh
docker push <your-dockerhub-username>/flask-app:latest
```

### 4️⃣ Deploy to Kubernetes (EKS)
Create a **Kubernetes deployment** YAML file (`deployment.yaml`):
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: flask-app
  template:
    metadata:
      labels:
        app: flask-app
    spec:
      containers:
      - name: flask-app
        image: <your-dockerhub-username>/flask-app:latest
        ports:
        - containerPort: 5000
```

Apply the deployment:
```sh
kubectl apply -f deployment.yaml
```

### 5️⃣ Expose the Application via a LoadBalancer
Create a **Kubernetes Service** YAML file (`service.yaml`):
```yaml
apiVersion: v1
kind: Service
metadata:
  name: flask-service
spec:
  type: LoadBalancer
  selector:
    app: flask-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 5000
```

Apply the service:
```sh
kubectl apply -f service.yaml
```

Get the **LoadBalancer URL**:
```sh
kubectl get svc flask-service
```

Test the app using the **EXTERNAL-IP** of the LoadBalancer.

### 6️⃣ Scaling the Application
Increase replicas:
```sh
kubectl scale deployment flask-app --replicas=3
```

Verify pods:
```sh
kubectl get pods
```

## 🧹 Cleanup
To delete all resources:
```sh
kubectl delete -f service.yaml
kubectl delete -f deployment.yaml
```

If using EKS and want to remove everything:
```sh
eksctl delete cluster --name <your-cluster-name>
```

## 📌 Summary
This guide helps you **migrate a local application** to **Kubernetes on AWS EKS** using Docker, Kubernetes Deployments, and LoadBalancers.

💬 **Need help? Open an issue!** 🚀
