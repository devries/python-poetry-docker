FROM python:3.12 AS builder
RUN pip install poetry==1.8.3
RUN poetry self add poetry-plugin-bundle

WORKDIR /app
COPY pyproject.toml poetry.lock ./
RUN touch README.md
COPY python_poetry_docker/ ./python_poetry_docker/
ENV POETRY_CACHE_DIR=/tmp/poetry_cache

RUN --mount=type=cache,target=$POETRY_CACHE_DIR poetry bundle venv --without=dev /venv

FROM python:3.12-slim
COPY --from=builder /venv /venv
ENV PATH="/venv/bin:$PATH"
ENV PYTHONPATH="/venv"

HEALTHCHECK NONE

CMD ["app"]
