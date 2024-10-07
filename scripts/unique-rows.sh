#!/bin/bash

# Перевіряємо, чи передано шлях як аргумент
if [ $# -ne 1 ]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

input_path=$1

# Якщо це файл, шукаємо унікальні рядки у файлі
if [ -f "${input_path}" ]; then
    echo "Unique lines in ${log_file}:"
    sort "${input_path}" | uniq
# Якщо це каталог, обробляємо всі файли у ньому
elif [ -d "${input_path}" ]; then
    for log_file in "${input_path}"/*; do
        if [ -f "${log_file}" ]; then
            echo "Unique lines in ${log_file}:"
            sort "${log_file}" | uniq
            echo "-----------------------------------"
        fi
    done
else
    echo echo "Error: File '${log_file}' not found!"
    exit 1
fi
