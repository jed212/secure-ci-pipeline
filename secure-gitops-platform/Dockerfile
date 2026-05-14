# ---------- Build Stage ----------
FROM golang:1.24.14-alpine AS builder

WORKDIR /src

# Copy go modules (better caching)
COPY app/go.mod ./

RUN go mod download

# Copy source code
COPY app/ .

# Build binary (static, linux)
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o server ./cmd/server

# ---------- Runtime Stage ----------
FROM alpine:3.20

# Create non-root user 
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy binary from builder
COPY --from=builder /src/server .

# Use non-root user
USER appuser

# Expose service port
EXPOSE 8080

# Run binary
CMD ["./server"]
