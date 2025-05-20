FROM python:3.10-slim

WORKDIR /app

# نصب پیش‌نیازها
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    rm -rf /var/lib/apt/lists/*

# کپی و نصب requirements
COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# کپی تمام فایل‌ها
COPY . .

# تنظیم متغیرهای محیطی
ENV PYTHONPATH=/app
ENV STATIC_ROOT=/app/staticfiles

# ایجاد پوشه استاتیک و جمع‌آوری فایل‌ها
RUN mkdir -p staticfiles && \
    python manage.py collectstatic --noinput

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]
