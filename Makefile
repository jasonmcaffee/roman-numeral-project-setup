# Roman Numeral Application Makefile
# Simplified commands for building, running, and stopping the application stack

.PHONY: clone-build-run-roman-numeral-stack clone-repos build-and-run-roman-numeral-stack open-roman-numeral-ui-in-the-browser stop

clone-build-run-roman-numeral-stack: clone-repos build-and-run-roman-numeral-stack open-roman-numeral-ui-in-the-browser

clone-repos:
	@echo "Cloning roman-numeral-service and roman-numeral-ui repos"
	git clone https://github.com/jasonmcaffee/roman-numeral-service.git
	git clone https://github.com/jasonmcaffee/roman-numeral-ui.git

# Build and run the complete application stack with DataDog monitoring
build-and-run-roman-numeral-stack:
	@echo "Building and starting Roman Numeral application stack with monitoring using passed in DD_API_KEY: $$DD_API_KEY ..."
	docker-compose --profile monitoring up -d --build
	@echo "Application started! Access at:"
	@echo "  Frontend: http://localhost:3001"
	@echo "  Backend:  http://localhost:3000"
	@echo "  Health:   http://localhost:3000/health"
	@echo "  DataDog:  http://localhost:8126"

open-roman-numeral-ui-in-the-browser:
	@echo "Opening http://localhost:3001/integer-to-roman-numeral in your browser..."
	open http://localhost:3001/integer-to-roman-numeral

# Stop all containers
stop:
	@echo "Stopping all containers..."
	docker-compose down
	@echo "All containers stopped."
