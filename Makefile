# Roman Numeral Application Makefile
# Simplified commands for building, running, and stopping the application stack

.PHONY: build-and-run-roman-numeral-stack stop

# Build and run the complete application stack with DataDog monitoring
build-and-run-roman-numeral-stack:
	@echo "Building and starting Roman Numeral application stack with monitoring..."
	DD_API_KEY=442a78ca506fed3b4ffd4453de073fd2 docker-compose --profile monitoring up -d --build
	@echo "Application started! Access at:"
	@echo "  Frontend: http://localhost:3001"
	@echo "  Backend:  http://localhost:3000"
	@echo "  Health:   http://localhost:3000/health"
	@echo "  DataDog:  http://localhost:8126"

# Stop all containers
stop:
	@echo "Stopping all containers..."
	docker-compose down
	@echo "All containers stopped." 