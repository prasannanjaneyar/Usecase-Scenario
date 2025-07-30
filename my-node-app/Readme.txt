Creating node js application docker image.
1) the floder structure as like
 my-node-app
  Dockerfile
  app.js
  package.json
the sample code is available in the file.
#First we need to create docker image from the Dockerfile the command is:
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
#we need to create azure contianer registery in azure portal(here the acr name is -containerregi.azurecr.io)
#Log in to your ACR
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
===========================
commands:
az acr login --name containerregi.azurecr.io
az acr show --name containerregi.azurecr.io --query "loginServer" --output tsv
docker tag node-docker-sample containerregi.azurecr.io/node-docker-sample:v1
docker push containerregi.azurecr.io/node-docker-sample:v1
az acr repository list --name containerregi.azurecr.io --output table