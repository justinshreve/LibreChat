# Build stage
FROM node:20-alpine AS base
WORKDIR /app
RUN apk --no-cache add curl
RUN npm config set fetch-retry-maxtimeout 600000 && \
    npm config set fetch-retries 5 && \
    npm config set fetch-retry-mintimeout 15000

# Copy package files
COPY package*.json ./
COPY packages/data-provider/package*.json ./packages/data-provider/
COPY client/package*.json ./client/

# Install dependencies
FROM base AS deps
WORKDIR /app
RUN npm ci && cd client && npm ci

# Build data-provider
FROM deps AS data-provider-build
WORKDIR /app/packages/data-provider
COPY packages/data-provider ./
RUN npm run build

# Client build
FROM deps AS client-build
WORKDIR /app/client
# Add build argument for cache busting
ARG CACHE_BUST=unknown
COPY client ./
COPY --from=data-provider-build /app/packages/data-provider/dist /app/packages/data-provider/dist
ENV NODE_OPTIONS="--max-old-space-size=2048"
# Clear any previous builds and node_modules
RUN rm -rf dist node_modules/.vite
# Build with cache busting
RUN VITE_CACHE_BUST=$CACHE_BUST VITE_SKIP_CACHE=true NODE_ENV=production npm run build

# Production stage
FROM nginx:1.27.0-alpine
COPY --from=client-build /app/client/dist /usr/share/nginx/html
COPY client/nginx.conf /etc/nginx/conf.d/default.conf
