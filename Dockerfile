#syntax=docker/dockerfile:1.4

# This Dockerfile uses the root project folder as context.

# Versions
FROM python:3.10-slim AS python_upstream


# --
# App base image
FROM python_upstream AS app_base

WORKDIR /app

# Installing requirements
COPY --link ./Fooocus/requirements_versions.txt .
RUN pip install --no-cache-dir -r requirements_versions.txt && \
	# Clean up
	pip cache purge && \
	rm -rf /root/.cache/pip

# Set exposed port
ARG PORT=80
ENV PORT=${PORT}

# --
# Prod build image

FROM app_base AS app_prod

# Mount source code as volume
VOLUME /app

# Expose port
EXPOSE ${PORT}

CMD [ "python", "entry_with_update.py", "--listen" ]
