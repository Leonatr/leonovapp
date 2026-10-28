package main

import (
    "fmt"
    "net/http"
    "os"
)

func main() {
    port := os.Getenv("APP_PORT")
    if port == "" {
        port = "8080"
    }

    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Приложение работает от непривилегированного пользователя на порту: %s\n", port)
    })

    fmt.Printf("Сервер слушает порт %s...\n", port)
    http.ListenAndServe(":"+port, nil)
}
