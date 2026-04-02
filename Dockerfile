FROM golang:1.23-alpine AS builder

WORKDIR /app

# Copy toàn bộ source code
COPY . .

# Build PocketBase thành binary tĩnh
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o pocketbase ./examples/base

FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copy binary từ bước build
COPY --from=builder /app/pocketbase /usr/local/bin/pocketbase

# Tạo thư mục data
RUN mkdir -p /pb_data

EXPOSE 8090

CMD ["pocketbase", "serve", "--http=0.0.0.0:8090", "--dir=/pb_data"]
