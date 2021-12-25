# Install dependencies only when needed
FROM node:16-alpine AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package*.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Rebuild the source code only when needed
FROM node:16-alpine  AS builder
WORKDIR /app
COPY ./ ./
COPY --from=deps /app/node_modules ./node_modules
ENV NODE_ENV production
RUN yarn build && yarn install --production --ignore-scripts --prefer-offline

# Production image, copy all the files and run next
FROM node:16-alpine  AS runner
WORKDIR /app
ENV NODE_ENV production
RUN npm install --global pm2

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# You only need to copy next.config.js if you are NOT using the default configuration
COPY --from=builder /app/next.config.js ./
COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/build ./build
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

EXPOSE 3000
USER nextjs
ENV PORT 3000
ENV NEXT_TELEMETRY_DISABLED 1
CMD [ "pm2-runtime", "npm", "--", "start" ]
