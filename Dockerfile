# multi-stage builds by partition Dockerfile into stages
# each stage can be based on a completely different image

# stage-0
FROM python:3-slim-bullseye AS builder

# upgrading the system packages
RUN apt-get update && \
    apt-get upgrade --yes 

# creating a dedicated user
RUN useradd --create-home realpython
USER realpython
WORKDIR /home/realpython

# making a virtual environment
ENV VIRTUALENV=/home/realpython/venv 
RUN python3 -m venv $VIRTUALENV
ENV PATH="$VIRTUALENV/bin:$PATH"

COPY --chown=realpython pyproject.toml constraints.txt ./
RUN python -m pip install --upgrade pip setuptools && \
    python -m pip install --no-cache-dir -c constraints.txt ".[dev]"

COPY --chown=realpython src/ src/
COPY --chown=realpython test/ test/

RUN python -m pip install . -c constraints.txt && \
    python -m pytest test/unit/ && \
    python -m flake8 src/ && \
    python -m isort src/ --check && \
    python -m black src/ --check --quiet && \
    python -m pylint src/ --disable=C0114,C0116,R1705 && \
    python -m bandit -r src/ --quiet && \
	python -m pip wheel --wheel-dir dist/ . -c constraints.txt

# stage-1
FROM python:3-slim-bullseye

RUN apt-get update && \
    apt-get upgrade --yes 

RUN useradd --create-home realpython
USER realpython
WORKDIR /home/realpython

ENV VIRTUALENV=/home/realpython/venv 
RUN python3 -m venv $VIRTUALENV
ENV PATH="$VIRTUALENV/bin:$PATH"

# copying .whl from the builder stage
COPY --from-builder /home/realpython/dist/page_tracker*.whl /home/realpython

# install .whl with pip
RUN python -m pip install --upgrade pip setuptools && \
    python -m pip install --no-cache-dir page_tracker*.whl

# start webapp with Flask
CMD ["flask", "--app", "page_tracker.app", "run", \
     "--host", "0.0.0.0", "--port", "5000"]