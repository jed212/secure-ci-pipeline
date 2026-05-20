# ---------- Build Stage ----------
# Using specific digest for reproducibility
FROM golang:1.24-alpine@sha256:2d183a62f309990e668b3f17d7a9648939c0993952a65d70b024419b4864f77c AS builder

WORKDIR /src

# Copy go modules (better caching)
COPY app/go.mod ./
# COPY app/go.sum ./ # Uncomment if go.sum exists

RUN go mod download

# Copy source code
COPY app/ .

# Build binary (static, linux)
# Added flags for a smaller, more secure binary:
# -ldflags="-s -w" to strip symbol table and debug information
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" -o server ./cmd/server

# ---------- Runtime Stage ----------
# Using distroless for the smallest possible attack surface
FROM gcr.io/distroless/static-debian12:latest@sha256:7263300f91753086eb0a473c242337d1d4d16f805a22d767117f8b965f80b95f

WORKDIR /app

# Copy binary from builder
COPY --from=builder /src/server .

# Run as non-root (distroless/static has 'nonroot' user by default with UID 65532)
USER nonroot:nonroot

# Expose service port
EXPOSE 8080

# Run binary
ENTRYPOINT ["/app/server"]
