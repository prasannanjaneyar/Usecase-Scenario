Creating node js application docker image.
1) the floder structure as like
 my-node-app
  Dockerfile
  app.js
  package.json
the sample code is available in the file.
#First we need to Build Docker image from the Dockerfile the command is:
#Build Docker image
docker build -t node-docker-sample .

#Check docker image is avaiable or not
docker images -a

#Once build is completed you can run the container application is working or not.
# Run container
docker run -p 3000:3000 node-docker-sample - when we run the command it will show like below.

output:
PS C:\Github\automation\Usecase Scenario\my-node-app> docker run -p 3000:3000 node-docker-sample
App listening at http://localhost:3000
you can test the application using the url.

#Before pushing the docker image to Azure container registery, 
#we need to create azure contianer registery in azure portal(ACR name is - containerregi.azurecr.io)
#First login to Azure and Log in to your ACR

az login  or az login --use-device-code

az acr login --name containerregi.azurecr.io

#Get the login server name:
az acr show --name myregistry --query "loginServer" --output tsv

#Once Docker image is build you can tag the version
#Tag your image with ACR login server
docker tag node-docker-sample containerregi.azurecr.io/node-docker-sample:v1

#push to azure container registeried
#Push the image to ACR
docker push containerregi.azurecr.io/node-docker-sample:v1

#Check the image is avaiable or not in acr
#Verify upload
az acr repository list --name containerregi.azurecr.io --output table

Now the Docker image is avaiable in ACR.
Build is completed CI
#Deploy the docker image to AKS and testt he application.
#Now deployment stage.
#Create AKS cluster using the terraform or azure portal.
#integration between Azure Kubernetes Service (AKS) and Azure Container Registry (ACR) to enable secure image pulling.
#Using the data argument we can import the acr and Role Assignment.
Once AKS is deployed,go to azure devops orginixation -> create new project.
create service connections for docker hub service, aks and azure subscription - grant the pipeline access to run the pipeline automatically.
you can see the pipeline steps in azure-pipeline.yml.
Create deployment.yml file to deploy the pod in aks.

===========================
commands:
az acr login --name containerregi.azurecr.io
az acr show --name containerregi.azurecr.io --query "loginServer" --output tsv
docker tag node-docker-sample containerregi.azurecr.io/node-docker-sample:v1
docker push containerregi.azurecr.io/node-docker-sample:v1
az acr repository list --name containerregi.azurecr.io --output table
=================================
sample deployment.yml file:

apiVersion: apps/v1
kind: Deployment
metadata:
  name: node-sample
  labels:
    app: node-sample               # <-- Add this
spec:
  replicas: 1
  selector:
    matchLabels:
      app: node-sample
  template:
    metadata:
      labels:
        app: node-sample
    spec:
      containers:
        - name: node-sample
          image: containerregi.azurecr.io/node-docker-sample:latest
          ports:
            - containerPort: 3000

=================================================================

sample azure-pipeline.yml
# Starter pipeline
# Start with a minimal pipeline that you can customize to build and deploy your code.
# Add steps that build, run tests, deploy, and more:
# https://aka.ms/yaml
---
trigger:
  branches:
    include:
      - main
variables:
  imageName: node-docker-sample
  tag: $(Build.BuildId)
stages:
  - stage: BuildAndPush
    displayName: Build and Push to ACR
    jobs:
      - job: Build
        displayName: Build and Push Docker Image
        pool:
          vmImage: ubuntu-latest
        steps:
          - checkout: self
          - task: Docker@2
            displayName: 'Login to Docker Hub'
            inputs:
              containerRegistry: 'DockerHubServiceConnection'
              command: 'login'

          - task: Docker@2
            displayName: Build Docker image
            inputs:
              containerRegistry: ACR-SVC
              repository: $(imageName)
              command: build
              Dockerfile: Dockerfile
              buildContext: $(Build.SourcesDirectory)
              tags: |
                $(tag)
                latest
          - task: Docker@2
            displayName: Push image to ACR
            inputs:
              containerRegistry: ACR-SVC
              repository: $(imageName)
              command: push
              tags: |
                $(tag)
                latest
  - stage: Deploy
    displayName: Deploy to AKS
    jobs:
    - deployment: DeployApp
      displayName: Deploy to AKS Cluster
      environment: aks-dev
      strategy:
        runOnce:
          deploy:
            steps:
              - checkout: self  # Add this line
              
              - script: |
                  echo "Current working directory:"
                  pwd
                  echo "Listing contents:"
                  ls -la $(System.DefaultWorkingDirectory)
                  echo "Build sources directory:"
                  ls -la $(Build.SourcesDirectory)
                displayName: "Debug: Show working directory contents"


              - task: Kubernetes@1
                displayName: Apply deployment to AKS
                inputs:
                  connectionType: 'Azure Resource Manager'
                  azureSubscriptionEndpoint: 'My-Azure-RM-Connection'
                  azureResourceGroup: 'rg-aks-demo'
                  kubernetesCluster: 'aks-demo'
                  namespace: 'default'
                  command: 'apply'
                  useConfigurationFile: true
                  configuration: '$(Build.SourcesDirectory)/deployment.yaml'
                  secretType: 'None'
