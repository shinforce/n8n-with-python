FROM n8nio/n8n:latest

USER root

# Install Python and PostgreSQL client
RUN apk update && \
    apk add --no-cache \
    python3 \
    py3-pip \
    postgresql-client \
    && rm -rf /var/cache/apk/*

# Create virtual environment
RUN python3 -m venv /opt/venv && \
    chown -R node:node /opt/venv

# Copy requirements
COPY --chown=node:node requirements.txt /tmp/requirements.txt
RUN if [ -f /tmp/requirements.txt ]; then \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install --no-cache-dir -r /tmp/requirements.txt; \
    fi

# Create symlinks
RUN ln -sf /opt/venv/bin/python /usr/local/bin/python && \
    ln -sf /opt/venv/bin/pip /usr/local/bin/pip

USER node

ENV PATH="/opt/venv/bin:${PATH}"
