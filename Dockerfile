# Base on offical Node.js Alpine image
FROM node:16-alpine
RUN apk add --no-cache libc6-compat
# Set working directory
WORKDIR /usr/app
# Install PM2 globally
RUN npm install --global pm2
# Copy package.json and package-lock.json before other files
# Utilise Docker cache to save re-installing dependencies if unchanged
COPY package*.json yarn.lock ./
# Install dependencies
RUN yarn install --frozen-lockfile
# Copy all files
COPY ./ ./
# Build app
RUN NODE_ENV=production yarn build
# Expose the listening port
EXPOSE 3001
ENV NEXT_TELEMETRY_DISABLED 1
# Run container as non-root (unprivileged) user
# The node user is provided in the Node.js Alpine base image
USER node
# Run npm start script with PM2 when container starts
CMD [ "pm2-runtime", "npm", "--", "start" ]
