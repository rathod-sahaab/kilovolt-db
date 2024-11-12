# Kilovolt-DB

Kilovolt-DB is a high-performance, in-memory, multi-threaded, and clustered database designed to prioritize availability and partition tolerance (AP) according to the CAP theorem. It is built with **Golang** and utilizes **gRPC** as its primary communication protocol for efficient, low-latency interactions.

Kilovolt-DB is optimized for environments that require high scalability and fault tolerance, such as distributed systems, microservices, and real-time applications.

---

## Features

- **In-Memory**: Data is stored entirely in memory for extremely fast read and write operations.
- **Multi-threaded**: Fully concurrent design using Go's goroutines to ensure high throughput and responsiveness across multiple threads.
- **Clustered**: Supports horizontal scaling with automatic node discovery and sharding.
- **AP-Optimized (CAP Theorem)**: Prioritizes **Availability** and **Partition Tolerance**, ensuring that the database remains available and functional even during network partitions, at the expense of consistency.
- **gRPC Communication**: Efficient and low-latency communication between nodes and clients using the gRPC protocol.
- **Easy to Scale**: As a clustered system, Kilovolt-DB can dynamically add or remove nodes, with minimal impact on performance.

---

## Getting Started

### Prerequisites

- **Go 1.18+**: Kilovolt-DB is built using Go and requires Go 1.18 or higher.
- **gRPC**: gRPC is used for communication between nodes and clients.
- **Protobuf**: Protocol Buffers are used to define the gRPC service and data structures.

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/kilovolt-db.git
   cd kilovolt-db
   ```

2. Install the required Go dependencies:

   ```bash
   go mod tidy
   ```

3. Build the project:

   ```bash
   go build -o kilovolt-db
   ```

4. (Optional) Run tests:

   ```bash
   go test ./...
   ```

---

## Usage

### Running the Kilovolt-DB Server

To start a single-node instance of Kilovolt-DB:

```bash
./kilovolt-db --port 50051
```

This will start a gRPC server on port `50051` by default. You can adjust the port using the `--port` flag.

### Running a Cluster of Nodes

To start a multi-node cluster, you can start multiple instances of Kilovolt-DB with different ports, and they will automatically discover and join each other:

```bash
./kilovolt-db --port 50051 --cluster "localhost:50052,localhost:50053"
./kilovolt-db --port 50052 --cluster "localhost:50051,localhost:50053"
./kilovolt-db --port 50053 --cluster "localhost:50051,localhost:50052"
```

Each node will automatically connect to the other nodes in the cluster, forming a distributed system.

### Client Interaction via gRPC

Kilovolt-DB exposes a simple gRPC API for storing and retrieving key-value data. A sample client can be written in Go as follows:

```go
package main

import (
    "context"
    "fmt"
    "log"
    "google.golang.org/grpc"
    "kilovolt-db/proto"
)

func main() {
    conn, err := grpc.Dial("localhost:50051", grpc.WithInsecure())
    if err != nil {
        log.Fatalf("could not connect to server: %v", err)
    }
    defer conn.Close()

    client := proto.NewKilovoltClient(conn)

    // Example: Set a key-value pair
    setResp, err := client.Set(context.Background(), &proto.SetRequest{Key: "foo", Value: "bar"})
    if err != nil {
        log.Fatalf("could not set key: %v", err)
    }
    fmt.Println("Set response:", setResp.Status)

    // Example: Get a value by key
    getResp, err := client.Get(context.Background(), &proto.GetRequest{Key: "foo"})
    if err != nil {
        log.Fatalf("could not get key: %v", err)
    }
    fmt.Println("Got value:", getResp.Value)
}
```

This client connects to the server using gRPC, sets a key-value pair, and retrieves it.

### Configuration

Kilovolt-DB can be configured via command-line flags or environment variables:

- `--port`: The port for the gRPC server to listen on (default: `50051`).
- `--cluster`: Comma-separated list of other nodes to join the cluster (e.g., `"localhost:50052,localhost:50053"`).
- `--log-level`: Set the logging level (`info`, `debug`, `error`, etc.).

---

## Architecture

Kilovolt-DB uses a **distributed hash table (DHT)** for sharding and distributing data across nodes in the cluster. Each node maintains a local store of key-value pairs and periodically syncs with other nodes in the cluster to ensure availability and partition tolerance.

Key components of the architecture include:

1. **Data Store**: In-memory key-value store using Go maps or a similar high-performance data structure.
2. **gRPC API**: Exposes methods for interacting with the database, including `Set`, `Get`, and `Delete`.
3. **Cluster Discovery**: Nodes automatically discover each other using a gossip-based protocol, forming a resilient cluster.
4. **Multi-threading**: Internal use of Go's goroutines to handle concurrent read and write operations with minimal contention.

### CAP Theorem

Kilovolt-DB prioritizes **Availability** and **Partition Tolerance** over **Consistency** in accordance with the **AP** characteristics of the CAP theorem. This means that:

- **Availability**: The database will always be available for reads and writes, even if some nodes are unreachable or the network is partitioned.
- **Partition Tolerance**: The system will continue to operate even if some nodes are temporarily disconnected from the cluster.

### Fault Tolerance

Kilovolt-DB is designed with resilience in mind. If a node crashes or is disconnected from the network, the cluster will automatically recover, ensuring continued availability of the database. Data replication is handled by the cluster, with each node holding a portion of the overall data.

---

## Contributing

Kilovolt-DB is an open-source project, and contributions are welcome! If you have an idea for a feature or improvement, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit them (`git commit -am 'Add new feature'`).
4. Push to your branch (`git push origin feature-branch`).
5. Open a pull request.

Make targets:

- **`all`**: The default target which builds the project by calling the `build` target.
- **`build`**: Compiles the Go project and outputs the binary into the `bin` directory.
- **`run`**: Runs the built binary after it has been compiled, which will start the Kilovolt-DB server.
- **`test`**: Runs the unit tests for the project using `go test`.
- **`test-cover`**: Runs tests with coverage and generates a coverage report in both `.out` and `.html` formats.
- **`clean`**: Cleans the Go build cache.
- **`fmt`**: Runs `go fmt` to format the Go source code files.
- **`generate-proto`**: Placeholder target to generate gRPC and Protobuf code using the `protoc` command. (You would need to define the appropriate `protoc` commands for your specific `.proto` files).
- **`install`**: Runs `go mod tidy` to update and install Go dependencies.
- **`clean-all`**: Removes the compiled binary and build artifacts from both the `bin` and `build` directories.

---

### Usage

- To **build** the project:

  ```bash
  make build
  ```

- To **run** the project:

  ```bash
  make run
  ```

- To **run tests**:

  ```bash
  make test
  ```

- To **run tests with coverage**:

  ```bash
  make test-cover
  ```

- To **format the Go code**:

  ```bash
  make fmt
  ```

- To **clean** build artifacts:

  ```bash
  make clean
  ```

- To **clean everything** (including binaries):

  ```bash
  make clean-all
  ```

- To **install dependencies** (via Go modules):

  ```bash
  make install
  ```

---

## License

Kilovolt-DB is released under the **MIT License**. See `LICENSE` for more details.

---

## Acknowledgments

Kilovolt-DB is built on the shoulders of giants. Key dependencies include:

- **Go** (Golang) for concurrency and performance.
- **gRPC** for fast, cross-platform communication.
- **Protocol Buffers (protobuf)** for efficient serialization and API definitions.

---

Feel free to reach out with any questions or feedback!
