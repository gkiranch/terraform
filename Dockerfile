# syntax=docker/dockerfile:1.4
# Production Dockerfile for Node.js Express app
FROM node:16-alpine

# Create app directory
WORKDIR /usr/src/app

# Set production environment
ENV NODE_ENV=production
ENV NPM_CONFIG_FETCH_RETRIES=5 \
    NPM_CONFIG_FETCH_RETRY_MINTIMEOUT=20000 \
    NPM_CONFIG_FETCH_RETRY_MAXTIMEOUT=120000 \
    NPM_CONFIG_UPDATE_NOTIFIER=false \
    NPM_CONFIG_FUND=false \
    NPM_CONFIG_AUDIT=false

# Install app dependencies
# Leverage cached layers by copying only package files first
COPY package*.json ./
RUN npm i -g npm@6
ARG NPM_REGISTRY
RUN if [ -n "$NPM_REGISTRY" ]; then npm config set registry "$NPM_REGISTRY"; fi
RUN --mount=type=cache,target=/root/.npm npm ci --only=production --progress=false

# Bundle app source
COPY . .

# The app listens on port 3000 by default
EXPOSE 3000

# Start the server
# Prefer a single process in containers; run directly with node
CMD ["node", "server.js"]
