## Використано image based approach з використанням python-slim ###
#FROM python:3.11-slim
#LABEL authors="Chaban"
#
## Встановлюємо робочу директорію
#WORKDIR /app
#COPY requirements.txt .
#RUN pip install -r requirements.txt
#
## Копіюємо весь код застосунку в контейнер
#COPY . /app
#
## Відкриваємо порт 5000 для FastAPI
#EXPOSE 5000
#
#CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]


### Використання milti staging + based images approach###
FROM python:3.11-slim AS builder
LABEL authors="Chaban"

WORKDIR /app
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt


# Етап 2: створення кінцевого легкого образу
FROM python:3.11-alpine
WORKDIR /app
COPY --from=builder /root/.local /root.local

# Додаємо шлях до встановлених бібліотек
ENV PATH=/root/.local/bin:$PATH

COPY --from=builder /app /app

EXPOSE 5000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]