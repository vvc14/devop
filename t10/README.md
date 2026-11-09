## 1. What is container orchestration, and why is Kubernetes used for it?

### Container Orchestration: The automated management, scaling, networking, and deployment of containerized applications across a cluster of host machines.

### Why Kubernetes: It automates high-availability tasks that are impossible to manage manually at scale—including automatic self-healing (restarting failed containers), rolling updates without downtime, load balancing, service discovery, and dynamic auto-scaling.

## 2. How do Docker and Kubernetes work together when deploying an application?

### Docker (Packaging): Packages application code, dependencies, and runtime environment into an immutable container image.

### Kubernetes (Execution & Management): Uses that Docker image as a blueprint to schedule, run, scale, and network container instances (Pods) across nodes in a cluster. Docker builds the box; Kubernetes manages the fleet of boxes.