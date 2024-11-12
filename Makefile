# Go binary name
BINARY_NAME=kilovolt-db

# Go-related variables
GO=go
GOFMT=$(GO) fmt
GOTEST=$(GO) test
GOCLEAN=$(GO) clean

# Directories
BIN_DIR=bin
BUILD_DIR=build
PROTO_DIR=proto

# Flags
GOFLAGS=-v

# Default target
.PHONY: all
all: build

# Build the project
.PHONY: build
build: clean
	$(GO) build -o $(BIN_DIR)/$(BINARY_NAME) .

# Run the project
.PHONY: run
run: build
	$(BIN_DIR)/$(BINARY_NAME)

# Run tests
.PHONY: test
test:
	$(GOTEST) ./...

# Run tests with coverage report
.PHONY: test-cover
test-cover:
	$(GOTEST) -coverprofile=coverage.out ./...
	$(GO) tool cover -html=coverage.out -o coverage.html

# Clean build artifacts
.PHONY: clean
clean:
	$(GOCLEAN)

# Format Go files
.PHONY: fmt
fmt:
	$(GOFMT) ./...

# Generate Protobuf code
.PHONY: generate-proto
generate-proto:
	# Add the command to generate gRPC and Protobuf code here
	# Example:
	# protoc --go_out=. --go-grpc_out=. $(PROTO_DIR)/*.proto

# Install dependencies (go mod)
.PHONY: install
install:
	$(GO) mod tidy

# Remove binary and build artifacts
.PHONY: clean-all
clean-all: clean
	rm -rf $(BIN_DIR)/$(BINARY_NAME)
	rm -rf $(BUILD_DIR)

