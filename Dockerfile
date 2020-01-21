FROM golang:1.13-stretch as builder

WORKDIR /app

# Copy go.mod etc and download dependencies (leverage docker layer caching)
COPY go.mod go.sum ./

RUN go mod download

# Copy source code over
COPY . .

# Build
RUN go build -o main .

EXPOSE 8080

CMD ["./main"]
