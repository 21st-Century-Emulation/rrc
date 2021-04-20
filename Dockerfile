FROM golang:1.16.2 AS builder
WORKDIR /usr/local/go/src/rrc
COPY go.mod ./
RUN go mod download
COPY main.go ./
RUN CGO_ENABLED=0 go build -ldflags '-extldflags "-static"' -o /rrc .
RUN chmod +x /rrc

FROM scratch
COPY --from=builder /rrc .
ENTRYPOINT ["/rrc"]