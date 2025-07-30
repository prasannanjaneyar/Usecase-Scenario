# Use an official Node.js base image
#FROM node:18-alpine
FROM containerregi.azurecr.io/node-docker-sample:latest

# Set working directory inside container
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install --production

# Copy the rest of the application code
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Start the app
CMD ["node", "app.js"]
