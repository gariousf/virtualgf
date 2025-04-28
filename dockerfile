# Dockerfile

# Use an official Node.js runtime as a parent image
# Choose a version that matches your development environment or project requirements
# Using LTS (Long Term Support) versions is generally recommended
FROM node:18-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
# Copying these first leverages Docker layer caching
COPY package.json ./
COPY package-lock.json* ./
# Make sure yarn.lock and bun.lock.json are commented out if present
# COPY yarn.lock ./
# COPY bun.lock.json ./

# Install dependencies using npm
RUN npm install
# Make sure other install commands are commented out
# RUN yarn install
# RUN bun install

# Copy the rest of your application code
COPY . .

# Build the application using npm script
RUN npm run build

# --- Production Stage ---
# Use a smaller base image for the production stage
FROM node:18-alpine

WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app/package.json ./
# Copy package-lock.json as well, it might be needed by some tools or for consistency
COPY --from=builder /app/package-lock.json* ./
COPY --from=builder /app/node_modules ./
COPY --from=builder /app/dist ./dist

# Expose the port the app runs on (vite preview defaults to 4173)
EXPOSE 4173

# Command to run the application using the npm start script
# This uses the "start": "vite preview --host" script from your package.json
CMD ["npm", "run", "start"]
