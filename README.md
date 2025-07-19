# Roman Numeral Project Setup
This project serves as a repo for convenience make commands that facilitate:
- cloning the [roman-numeral-service](https://github.com/jasonmcaffee/roman-numeral-service)
- cloning the [roman-numeral-ui](https://github.com/jasonmcaffee/roman-numeral-ui)
- using docker compose to start the full stack:
    - datadog-agent - used for sending logs, traces, metrics to datadog
    - roman-numeral-service - roman numeral backend service
    - roman-numeral-ui - roman numeral react ui

## Environment Requirements
### Make
This is used mainly for convenience commands, so isn't a hard requirement.
```shell
xcode-select --install
```

### Docker Desktop
Allows for docker builds, docker compose, etc. 

Download manually [here](https://www.docker.com/products/docker-desktop/) or install via brew
```shell
brew install --cask docker
```

## Setup
To clone, build, and run the entire stack, run the following command, optionally passing in your DD_API_KEY:
```shell
DD_API_KEY=1234 make clone-build-run-roman-numeral-stack
```

Or alternatively:
```shell
git clone https://github.com/jasonmcaffee/roman-numeral-service.git
git clone https://github.com/jasonmcaffee/roman-numeral-ui.git
docker-compose --profile monitoring up -d --build
open http://localhost:3001/integer-to-roman-numeral
```

This will result in the service, ui, and dd-agent being started, and the main page being opened in your browser:
![img.png](img.png)

## Teardown 
To stop the service:
```shell
make stop
```
