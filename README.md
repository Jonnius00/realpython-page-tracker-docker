# Page Tracker

[![Python Version](https://img.shields.io/badge/python-3.11-blue.svg)](https://www.python.org/downloads/release/python-3110/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A web application that tracks page views with Flask and Redis, demonstrating Docker containerization best practices.

## Overview

Page Tracker is a Flask web application that counts and displays the number of page views, storing the counter in a Redis database. This project implements the architecture and practices described in the Real Python tutorial [Docker in Continuous Integration](https://realpython.com/docker-continuous-integration/).

Key features:

- Flask web application with Redis backend
- Containerized with Docker and orchestrated with Docker Compose
- Comprehensive testing suite (unit, integration, end-to-end)
- Development environment with code quality tools

## Project Structure

```
.
├── web/                      # Web application code
│   ├── src/                  # Source code
│   │   └── page_tracker/     # Main package
│   │       ├── app.py        # Flask application
│   │       └── __init__.py   # Package initialization
│   ├── test/                 # Test suite
│   │   ├── conftest.py       # Test fixtures and configuration
│   │   ├── unit/             # Unit tests
│   │   ├── integration/      # Integration tests
│   │   └── e2e/              # End-to-end tests
│   ├── Dockerfile            # Production container definition
│   ├── Dockerfile.dev        # Development container with testing tools
│   ├── pyproject.toml        # Project metadata and dependencies
│   └── constraints.txt       # Pinned dependencies for reproducibility
├── docker-compose.yml        # Service orchestration
└── .gitignore                # Git ignore file
```

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/get-started/)
- [Docker Compose](https://docs.docker.com/compose/install/) (included with Docker Desktop)

### Running the Application

The easiest way to run Page Tracker is using Docker Compose:

```sh
docker compose up
```

This will start both the web application and Redis database. The application will be accessible at [http://localhost:80](http://localhost:80).

To run in detached mode:

```sh
docker compose up -d
```

To stop the application:

```sh
docker compose down
```

### Development Setup

For development with testing and code quality tools:

```sh
cd web
docker build -f Dockerfile.dev -t page-tracker-dev .
docker run -it -v "$(pwd):/app" page-tracker-dev bash
```

This gives you a shell inside the development container with all tools installed.

## Testing

The project includes three levels of tests:

### Unit Tests

Test individual components in isolation:

```sh
cd web
pytest test/unit/
```

### Integration Tests

Test the interaction between the Flask application and Redis:

```sh
cd web
pytest test/integration/
```

### End-to-End Tests

Test the complete system through HTTP requests:

```sh
# Start the application
docker compose up -d

# Run E2E tests
pytest test/e2e/ --flask-url http://localhost:80 --redis-url redis://localhost:6379
```

### Running All Tests

```sh
cd web
pytest
```

## Code Quality

The development environment includes several code quality tools:

- **Black**: Code formatter
- **isort**: Import sorter
- **Flake8**: Linter
- **Pylint**: Static analyzer
- **Bandit**: Security scanner

Run them with:

```sh
cd web
black src/ test/
isort src/ test/
flake8 src/ test/
pylint src/ test/
bandit -r src/
```

## API Endpoints

- `GET /`: Display the current page view count

## Environment Variables

- `REDIS_URL`: URL to the Redis instance (default: `redis://redis-service:6379`). Used by both the web and test services.
- `FLASK_URL`: URL to the Flask web service (default: `http://web-service:8000`). Used by the test service for end-to-end testing.

## Built With

- [Flask](https://flask.palletsprojects.com/) - Web framework
- [Redis](https://redis.io/) - Database
- [pytest](https://pytest.org/) - Testing framework
- [Docker](https://www.docker.com/) - Containerization

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [Real Python](https://realpython.com/) - For the original Docker CI tutorial