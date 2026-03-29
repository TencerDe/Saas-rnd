FROM python:3.12-slim-bullseye

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /code

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN apt-get update && apt-get install -y \
    libpq-dev \
    libjpeg-dev \
    libcairo2 \
    gcc \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt /tmp/requirements.txt
RUN pip install --upgrade pip
RUN pip install -r /tmp/requirements.txt

COPY . /code

ARG PROJ_NAME=cfehome

RUN printf "#!/bin/bash\n" > /code/runner.sh && \
    printf "RUN_PORT=\"\${PORT:-8000}\"\n" >> /code/runner.sh && \
    printf "python manage.py migrate --no-input\n" >> /code/runner.sh && \
    printf "gunicorn ${PROJ_NAME}.wsgi:application --bind 0.0.0.0:\$RUN_PORT\n" >> /code/runner.sh

RUN chmod +x /code/runner.sh

CMD ["/code/runner.sh"]