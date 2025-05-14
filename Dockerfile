FROM python:3.11.12-slim-bullseye

# System setup
ARG USERNAME=modeler
ARG USER_UID=1100
ARG USER_GID=1100
ARG REPO_URL=https://github.com/cseptesting/floatcsep.git
ARG BRANCH_NAME=hermes-interface

# System setup   (eventually, git should not be required)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git
# User setup
RUN groupadd --gid $USER_GID $USERNAME \
 && useradd --uid $USER_UID --gid $USER_GID --shell /bin/bash --create-home $USERNAME

# Create user and venv
USER $USERNAME
WORKDIR /app

# Set up Python venv
ENV VIRTUAL_ENV=/home/$USERNAME/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV PYTHONUNBUFFERED=1

# Eventually, floatcsep should be installed from a release
RUN python3 -m venv $VIRTUAL_ENV && pip install --upgrade pip setuptools wheel && pip install git+$REPO_URL@$BRANCH_NAME

RUN echo "asd"
# Copy testing data
COPY --chown=$USERNAME:$USERNAME config.yml  ch_region.csv ./
# Copy forecasts (it can be removed when creating a func to access Hermes web-interface)
COPY --chown=$USERNAME:$USERNAME   ./forecasts/ ./forecasts/

ENTRYPOINT ["floatcsep", "run", "config.yml"]