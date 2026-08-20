apiVersion: apps/v1
kind: Deployment
metadata:
  name: devops-app
spec:
  replicas: 2

  selector:
    matchLabels:
      app: devops-app

  template:
    metadata:
      labels:
        app: devops-app

    spec:
      containers:
        - name: devops-app
          image: jsy77/devops:v7
          ports:
            - containerPort: 80
