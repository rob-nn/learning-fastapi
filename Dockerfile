FROM python:3.11.5-slim
# This file contains a base python/poetry installation libs to access S3 storage and run pyspark sessions

# Python and pip configuration
ENV PYTHONFAULTHANDLER=1 \
   PYTHONUNBUFFERED=1 \
   PYTHONHASHSEED=random \
   PIP_NO_CACHE_DIR=off \
   PIP_DISABLE_PIP_VERSION_CHECK=on \
   PIP_DEFAULT_TIMEOUT=120

# POETRY INSTALLATION
ENV POETRY_VERSION=1.7.1
RUN pip install poetry==${POETRY_VERSION}

# Project initialization:
RUN poetry config virtualenvs.create false 

# Creating SECID user to execute the apps and services
ENV SHELL=/bin/bash
ENV PY_USER="secid"
ENV PY_UID="1000"
ENV PY_GID="100"
ENV PY_HOME="/home/${PY_USER}"
ENV mkdir "${PY_HOME}"
RUN useradd -ms /bin/bash -u  "${PY_UID}" "${PY_USER}"
RUN chown "${PY_USER}:${PY_GID}" "${PY_HOME}" 

WORKDIR /service
ENV ENV_ORIGIN_PATH="."
COPY ${ENV_ORIGIN_PATH}/poetry.lock /service/
COPY ${ENV_ORIGIN_PATH}/pyproject.toml /service/
COPY ${ENV_ORIGIN_PATH}/README.md /service/
COPY ${ENV_ORIGIN_PATH}/learning_fastapi /service/learning_fastapi

# Project initialization:
RUN poetry install $(test "$YOUR_ENV" == production && echo "--no-dev") --no-interaction --no-ansi

USER ${PY_UID}

CMD ["uvicorn", "learning_fastapi.main:app",  "--reload", "--port=8000", "--host=0.0.0.0"]