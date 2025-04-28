# Dockerfile

# Use an official Node.js runtime as a parent image
# Choose a version that matches your development environment or project requirements
# Using LTS (Long Term Support) versions is generally recommended
FROM node:18-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and lock file (if you have one, e.g., package-lock.json or yarn.lock)
# Copying these first leverages Docker layer caching
COPY package.json ./
# If you use npm:
COPY package-lock.json* ./
# If you use yarn:
# COPY yarn.lock ./
# If you use bun:
# COPY bun.lock.json ./

# Install dependencies
# If you use npm:
RUN npm install
# If you use yarn:
# RUN yarn install
# If you use bun:
# RUN bun install

# Copy the rest of your application code
COPY . .

# Build the application
RUN npm run build

# --- Production Stage ---
# Use a smaller base image for the production stage
FROM node:18-alpine

WORKDIR /app

# Copy only necessary files from the builder stage
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./
COPY --from=builder /app/dist ./dist

# Expose the port the app runs on (vite preview defaults to 4173)
EXPOSE 4173

# Command to run the application using the start script
# This uses the "start": "vite preview --host" script from your package.json
CMD ["npm", "run", "start"]