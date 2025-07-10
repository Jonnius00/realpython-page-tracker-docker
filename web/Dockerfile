# multi-stage builds by partition Dockerfile into stages
# each stage can be based on a completely different image

# STAGE-0 CREATES a TEMPORARY builder stage 
# so there will be no trace of it in the resulted Docker images
FROM python:3-slim-bullseye AS builder

# upgrading the system packages
RUN apt-get update && \
    apt-get upgrade --yes 

# CREATES a dedicated user
RUN useradd --create-home realpython
USER realpython
WORKDIR /home/realpython

# CREATES a virtual environment to avoid 
# a risk interfering with the Linux own system tools.
ENV VIRTUALENV=/home/realpython/venv 
RUN python3 -m venv $VIRTUALENV
# TRICK: instead of activating venv usually by a shell script, 
# the PATH var is updated by overriding the path to the python executable.
# bcs activation the virt.env. via RUN instruction 
# only lasts until the next instruction in Dockerfile 
# since each one starts a NEW shell session
ENV PATH="$VIRTUALENV/bin:$PATH"

# Only copy METADATA files, contains info about the project’s dependencies
#   from a HOST machine into the Docker IMAGE.
# By default, files are owned by the superuser, 
#   so the OWNERSHIP CHANGED to regular one created before
COPY --chown=realpython pyproject.toml constraints.txt ./

# In rare cases, an old version of pip can actually prevent
# the latest versions of other packages from installing, 
# to avoid this PIP is being UPDATED here along with 
# the upgrading setuptools to get the newest security patches
RUN python -m pip install --upgrade pip setuptools && \
    python -m pip install --no-cache-dir -c constraints.txt ".[dev]"

# COPYING & INSTALLING the app package makes NEW Docker layers. 
# Therefore, any changes in source code WON'T require reinstalling 
# dependencies saved in the previous cached layer.
COPY --chown=realpython src/ src/
COPY --chown=realpython test/ test/

# BAKING the automated TESTING tools into the build process 
# ensures that if ANY ONE of them returns a non-zero exit_status_code, 
# then building your Docker image will fail.
# 
# The reason for combining the individual commands in one long RUN
# is to reduce the number of layers to cache. 
RUN python -m pip install . -c constraints.txt && \
    python -m pytest test/unit/ && \
    python -m flake8 src/ && \
    python -m isort src/ --check && \
    python -m black src/ --check --quiet && \
    python -m pylint src/ --disable=C0114,C0116,R1705 && \
    python -m bandit -r src/ --quiet && \
	python -m pip wheel --wheel-dir dist/ . -c constraints.txt

# STAGE-1 is building a distribution package
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
COPY --from=builder /home/realpython/dist/page_tracker*.whl /home/realpython

# INSTALL .whl with pip
RUN python -m pip install --upgrade pip setuptools && \
    python -m pip install --no-cache-dir page_tracker*.whl

# START WEBAPP with Flask 
# binding the host to the 0.0.0.0 address in order to
# make webapp accessible from outside the Docker container
CMD ["flask", "--app", "page_tracker.app", "run", \
     "--host", "0.0.0.0", "--port", "5000"]