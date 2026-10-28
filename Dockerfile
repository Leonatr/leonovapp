# Сборка приложения
FROM golang:1.20-alpine AS build

WORKDIR /app

# Копируем файл зависимостей и скачиваем их
COPY go.mod ./
RUN go mod download

# Копируем исходный код и собираем бинарный файл
COPY . .
RUN go build -o leonovapp main.go

# --- Этап 2: Финальный легковесный образ ---
FROM alpine:3.20

WORKDIR /app

# Переменная окружения для конфигурации
ENV APP_PORT=8080

# Установка необходимых утилит и очистка кэша
RUN apk add --no-cache ca-certificates && \
    rm -rf /var/cache/apk/*

# Создание непривилегированного пользователя и группы
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Копирование готового артефакта из первого этапа сборки
COPY --from=build /app/leonovapp ./leonovapp

# Настройка прав доступа на исполняемый файл
RUN chown appuser:appgroup ./leonovapp

# Переключение на непривилегированного пользователя
USER appuser

EXPOSE $APP_PORT

CMD ["./leonovapp"]
