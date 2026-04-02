# Build stage - dùng Go 1.25+
FROM golang:1.25-alpine AS builder

WORKDIR /app

# Copy toàn bộ source code
COPY . .

# Tải dependencies và build
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o pocketbase ./examples/base

# Runtime stage
FROM alpine:latest

RUN apk --no-cache add ca-certificates

WORKDIR /app

# Copy binary từ builder
COPY --from=builder /app/pocketbase /usr/local/bin/pocketbase

# Tạo thư mục lưu data
RUN mkdir -p /pb_data

EXPOSE 8080

# Command mặc định
CMD ["pocketbase", "serve", "--http=0.0.0.0:8090", "--dir=/pb_data"]
