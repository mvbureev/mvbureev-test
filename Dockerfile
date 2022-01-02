# Production image, copy all the files and run next
FROM nexus.mvbureev.tech:10010/node:16-alpine
RUN apk add --no-cache libc6-compat
WORKDIR /app
# ENV NODE_ENV production

RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

RUN npm install --global pm2

COPY package*.json yarn.lock .npmrc ./
RUN yarn --production --ignore-scripts --prefer-offline

# You only need to copy next.config.js if you are NOT using the default configuration
COPY next.config.js ./
COPY public ./public
COPY --chown=nextjs:nodejs build ./build
COPY package.json ./package.json

EXPOSE 3000
USER nextjs
ENV PORT 3000
ENV NEXT_TELEMETRY_DISABLED 1
CMD [ "pm2-runtime", "npm", "--", "start" ]
