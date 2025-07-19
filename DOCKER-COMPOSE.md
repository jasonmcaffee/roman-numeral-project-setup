# Docker Compose Configuration for Roman Numeral Application

This document describes the Docker Compose setup for running the complete Roman Numeral application stack with DataDog monitoring.

## Overview

The application consists of three main components:
- **Roman Numeral UI**: Next.js frontend application
- **Roman Numeral Service**: NestJS backend API service
- **DataDog Agent**: Monitoring and observability agent

## Quick Start

### Prerequisites

- Docker Desktop installed and running
- DataDog API key (optional, for monitoring)

### Running the Application

1. **Build and run the complete stack with monitoring:**
   ```bash
   make build-and-run-roman-numeral-stack
   ```

2. **Stop all containers:**
   ```bash
   make stop
   ```

## Services

### Roman Numeral UI (Frontend)

- **Port**: 3001 (mapped from container port 3000)
- **URL**: http://localhost:3001
- **Technology**: Next.js with React Spectrum UI
- **Features**: 
  - Modern, accessible UI components
  - Integer to Roman numeral conversion interface
  - Responsive design

### Roman Numeral Service (Backend)

- **Port**: 3000
- **URL**: http://localhost:3000
- **Health Check**: http://localhost:3000/health
- **Technology**: NestJS with TypeScript
- **Features**:
  - RESTful API for Roman numeral conversions
  - OpenAPI/Swagger documentation
  - DataDog APM integration
  - Structured logging with Pino
  - Health check endpoint

### DataDog Agent (Monitoring)

- **APM Port**: 8126
- **StatsD Port**: 8125/udp
- **Features**:
  - Application Performance Monitoring (APM)
  - Log collection and aggregation
  - Container monitoring
  - Metrics collection
  - Distributed tracing

## DataDog Integration

### Log Collection

The DataDog agent is configured to collect logs from:

1. **Application Logs**: Structured JSON logs from the NestJS service
   - Location: `/app/logs/roman-numeral-service.log`
   - Format: JSON with DataDog trace correlation
   - Includes: Request/response data, performance metrics, business logic logs

2. **Container Logs**: Docker container logs from all services
   - Automatic collection via Docker socket
   - Includes: UI and service container logs

3. **Configuration**: 
   - Service labels for automatic log correlation
   - Multi-line log processing
   - Source and service tagging

### APM (Application Performance Monitoring)

- **Distributed Tracing**: Automatic trace generation for HTTP requests
- **Service Maps**: Visual representation of service dependencies
- **Performance Metrics**: Response times, throughput, error rates
- **Custom Spans**: Business logic instrumentation

### Metrics

- **System Metrics**: CPU, memory, disk, network usage
- **Application Metrics**: Request rates, error rates, response times
- **Container Metrics**: Resource usage per container
- **Custom Metrics**: Business-specific metrics via StatsD

## Configuration Files

### docker-compose.yml

Main orchestration file that defines:
- Service configurations
- Network setup
- Volume mounts
- Environment variables
- Health checks
- DataDog integration

### DataDog Configuration (Shared)

The DataDog configuration files are shared from the `roman-numeral-service` directory to avoid duplication:

- **datadog.yaml**: Main DataDog agent configuration (from `../roman-numeral-service/datadog.yaml`)
- **conf.d/**: Service-specific configurations (from `../roman-numeral-service/conf.d/`)

This centralized approach ensures:
- Single source of truth for DataDog configuration
- Consistent monitoring setup across different deployment scenarios
- Easier maintenance and updates

## Environment Variables

### Required
- `DD_API_KEY`: DataDog API key for monitoring (set in Makefile)

### Optional
- `NODE_ENV`: Environment (production/development)
- `PORT`: Service port (default: 3000)
- `NEXT_PUBLIC_ROMAN_NUMERAL_SERVICE_BASE_URL`: Backend service URL

## Volumes

### Persistent Volumes
- `roman-numeral-logs`: Application log storage

### Bind Mounts
- `../roman-numeral-service/datadog.yaml`: DataDog agent configuration (shared)
- `../roman-numeral-service/conf.d`: DataDog service configurations (shared)
- `/var/run/docker.sock`: Docker socket for container monitoring
- `/proc/`, `/sys/fs/cgroup/`: System metrics collection
- `/var/lib/docker/containers`: Container log collection

## Networks

- `roman-numeral-network`: Custom bridge network for inter-service communication

## Health Checks

### Service Health Checks
- **Roman Numeral Service**: HTTP GET to `/health` endpoint
- **Roman Numeral UI**: HTTP GET to root endpoint
- **DataDog Agent**: Internal agent health monitoring

### Health Check Configuration
- **Interval**: 30 seconds
- **Timeout**: 10 seconds
- **Retries**: 3 attempts
- **Start Period**: 40 seconds (allows for initial startup)

## Monitoring Dashboard

### DataDog Features Available

1. **Logs Explorer**
   - Real-time log streaming
   - Structured log search and filtering
   - Log correlation with traces
   - Service-specific log views

2. **APM Services**
   - Service performance overview
   - Request flow visualization
   - Error rate monitoring
   - Response time percentiles

3. **Infrastructure**
   - Container resource usage
   - Host system metrics
   - Network connectivity
   - Storage utilization

4. **Custom Dashboards**
   - Business metrics
   - Application health
   - Performance trends
   - Error tracking

## Troubleshooting

### Log Collection Issues

1. **Check DataDog Agent Status:**
   ```bash
   docker exec dd-agent agent status
   ```

2. **Verify Log Files:**
   ```bash
   docker exec roman-numeral-service ls -la /app/logs/
   docker exec dd-agent ls -la /var/log/roman-numeral-service/
   ```

3. **Check Agent Logs:**
   ```bash
   docker logs dd-agent
   ```

### Common Issues

1. **Logs Not Appearing in DataDog**
   - Verify API key is correct
   - Check DataDog agent is running
   - Ensure log files are being written
   - Verify network connectivity

2. **APM Traces Not Showing**
   - Confirm DataDog tracer is initialized
   - Check agent connectivity on port 8126
   - Verify service is generating traffic

3. **Container Health Issues**
   - Check service logs for errors
   - Verify health check endpoints are responding
   - Ensure proper startup sequence

## Performance Considerations

### Resource Usage
- **Memory**: ~512MB per service container
- **CPU**: Minimal usage for typical workloads
- **Storage**: ~200MB for application images
- **Network**: Low bandwidth for monitoring data

### Scaling
- Services can be scaled horizontally
- DataDog agent supports multiple instances
- Load balancing can be added for high availability

## Security

### Network Security
- Services communicate over internal network
- External access only through defined ports
- DataDog agent uses HTTPS for data transmission

### Container Security
- Non-root user execution
- Read-only file systems where possible
- Minimal base images (Alpine Linux)
- Regular security updates

## Development Workflow

### Local Development
1. Start the stack: `make build-and-run-roman-numeral-stack`
2. Access services at defined URLs
3. Monitor via DataDog dashboard
4. Stop when done: `make stop`

### Debugging
- View logs: `docker-compose logs -f [service-name]`
- Execute commands: `docker exec -it [container-name] sh`
- Check health: `curl http://localhost:3000/health`

## Production Considerations

### High Availability
- Use multiple DataDog agent instances
- Implement service redundancy
- Configure proper health checks
- Set up monitoring alerts

### Performance Optimization
- Enable log compression
- Configure log retention policies
- Optimize DataDog agent settings
- Monitor resource usage

### Security Hardening
- Use secrets management for API keys
- Implement network policies
- Regular security updates
- Audit logging

## Support

For issues with:
- **Application**: Check service logs and health endpoints
- **DataDog**: Review agent status and configuration
- **Docker**: Verify container health and networking
- **Performance**: Monitor DataDog dashboards and metrics 