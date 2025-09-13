FROM node:20-alpine

RUN apk add --no-cache bash curl libc6-compat
WORKDIR /app

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash \
  && mv /root/.bun /opt/bun \
  && ln -s /opt/bun/bin/bun /usr/local/bin/bun

# Install deps with Bun
COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile || bun install

# Copy source
COPY . .

ENV NODE_ENV=production
ENV EXPO_NO_TELEMETRY=1
ENV EXPO_NON_INTERACTIVE=1
ENV PORT=8081

# Build static web
RUN bunx expo export --platform web

# Debug build output
RUN ls -la ./dist/ || echo "no dist"

EXPOSE 8081

# Start minimal server
CMD ["node", "backend/server.mjs"]