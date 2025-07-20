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

Note: we intentionally use the Spectrum TextField, rather than NumberField, as to allow for validation error messaging from the service to be demonstrated:
![img_1.png](img_1.png)

## Teardown 
To stop the service:
```shell
make stop
```

# High Level Overview
Each project has a detailed readme.md file that should be referenced.

## Frontend and Backend Projects
To create a setup similar to any mid to large scale application, I broke the frontend and backend into two separate projects.

- Next.js was used for the frontend app, as it does well with serving SSR and CSR react web applications.  See the project readme for further details.
- Nest.js was used for the backend service, as it provides key pieces of functionality that make service creation and maintenance easier. e.g. annotations for declarative controller behaviors, dependency injection, etc.  See the project readme for further details.

Having separate apps allows us to clearly separate our concerns, as well as allow for reusability and independent scaling, deployments, etc.

## Docker Compose
Since I built 2 docker containers, and use a third for DataDog Agent, I use docker compose to configure and run the projects.

## Roman Numeral Conversion Solution
I referenced the wiki for [Roman Numeral Conversion](https://en.wikipedia.org/wiki/Roman_numerals) to research the logic needed for integer to Roman numeral conversion, then implemented my own custom solution. 

Converting integers in range 1-3999 can be accomplished by:
- First breaking the number into decimal/place values.  e.g. 123 is 1 hundreds, 2 tens, 3 units.
  - We accomplish this with some simple division, flooring, and modulus operations.
- Next we find the roman numeral equivalent for each decimal/place value.
  - We accomplish this by having a separate array of values for each decimal/place value, then using the place value as an index to find the corresponding Roman numeral value.
- Finally, we combine the Roman numerals from each place value into a single string, and return the result

See the [service code](https://github.com/jasonmcaffee/roman-numeral-service/blob/b22da74454730e792b4a9ad666bb63d15ec39710/src/services/romanNumeral.service.ts#L14-L14) for more details.

## Observability
Datadog is used for metrics, logs, and traces.  See projects for screenshots and further details.

## Automated Testing
### Backend Service
The backend service uses integration and unit tests to ensure the correctness of the convert integer to roman numeral functionality.

### Frontend App
The frontend app tests following paradigms and libraries used in the react spectrum library, including using simulated user interactions to test desired functionality.
