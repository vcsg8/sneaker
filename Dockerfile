# Stage 1: Build frontend
FROM node:18 AS frontend
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --legacy-peer-deps
COPY ./src ./src
# COPY ./public ./public  # Removed because public directory does not exist
COPY ./webpack.config.js ./
COPY ./postcss.config.js ./
COPY ./tailwind.config.js ./
COPY ./tsconfig.json ./
RUN npx webpack build

# Stage 2: Build Go server
FROM golang:1.17 AS backend
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
# Copy frontend build into dist/ from frontend stage
COPY --from=frontend /app/dist ./dist
RUN go build -o sneaker ./cmd/sneaker-server/main.go

# Stage 3: Final image
FROM debian:bullseye-slim
WORKDIR /app
COPY --from=backend /app/sneaker ./sneaker
COPY --from=frontend /app/dist ./dist
COPY --from=backend /app/server ./server
COPY --from=backend /app/assets.go ./assets.go
COPY --from=backend /app/go.mod ./go.mod
COPY --from=backend /app/go.sum ./go.sum
COPY --from=backend /app/cmd ./cmd
COPY --from=backend /app/package.json ./package.json
COPY --from=backend /app/package-lock.json ./package-lock.json
COPY --from=backend /app/README.md ./README.md
COPY --from=backend /app/docs ./docs
COPY --from=backend /app/example.config.json ./example.config.json
COPY --from=backend /app/test-config.json ./test-config.json
COPY --from=backend /app/server ./server
COPY --from=backend /app/src ./src
COPY --from=backend /app/webpack.config.js ./webpack.config.js
COPY --from=backend /app/postcss.config.js ./postcss.config.js
COPY --from=backend /app/tailwind.config.js ./tailwind.config.js
COPY --from=backend /app/tsconfig.json ./tsconfig.json

# Entrypoint expects config at /config/config.json
VOLUME ["/config"]
EXPOSE 7788
CMD ["./sneaker", "--config", "/config/config.json"] 