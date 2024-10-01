FROM python:3.11-slim
LABEL authors="Chaban"

# Встановлюємо робочу директорію
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

# Копіюємо весь код застосунку в контейнер
COPY . /app

# Відкриваємо порт 5000 для FastAPI
EXPOSE 5000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "5000"]