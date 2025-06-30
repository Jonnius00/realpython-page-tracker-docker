# Page Tracker

This project is an implementation of the study material from the Real Python article:  
[Docker in Continuous Integration: Orchestrate Containers Using Docker Compose](https://realpython.com/docker-continuous-integration/#orchestrate-containers-using-docker-compose)

## Overview

Page Tracker is a simple Flask web application that tracks the number of times its main page has been viewed, storing the count in a Redis database. The project demonstrates best practices for:

- Containerizing Python applications with Docker
- Using Docker Compose for multi-container orchestration
- Implementing automated testing (unit, integration, and end-to-end)
- Enforcing code quality with tools like flake8, isort, black, pylint, and bandit
- Managing dependencies with `pyproject.toml` and constraints files

## Project Structure

```
.
├── src/
│   └── page_tracker/
│       ├── app.py
│       └── __init__.py
├── test/
│   ├── conftest.py
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── Dockerfile
├── Dockerfile.dev
├── pyproject.toml
├── constraints.txt
└── .gitignore
```

- **src/page_tracker/app.py**: Main Flask application logic.
- **test/**: Contains unit, integration, and end-to-end tests.
- **Dockerfile**: Production multi-stage Docker build.
- **Dockerfile.dev**: Development Docker build with testing and linting.
- **pyproject.toml**: Project metadata and dependencies.
- **constraints.txt**: Pinned dependency versions for reproducible builds.

## Running the Application

You can build and run the application using Docker:

```sh
docker build -t page-tracker .
docker run -p 5000:5000 page-tracker
```

Or, for development with live reload and testing tools:

```sh
docker build -f Dockerfile.dev -t page-tracker-dev .
docker run -p 5000:5000 page-tracker-dev
```

## Running Tests

Tests are organized into unit, integration, and end-to-end suites. To run all tests:

```sh
pytest
```

## License

This project is for educational purposes, based on the Real Python