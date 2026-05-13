package main

import (
	"log"
	"net/http"

	"secure-ci-cd-pipeline/internal/handlers"
)

func main() {
	mux := http.NewServeMux()

	mux.HandleFunc("/health", handlers.HealthHandler)

	server := &http.Server{
		Addr:    ":8080",
		Handler: mux,
	}

	log.Println("Server running on port 8080")

	if err := server.ListenAndServe(); err != nil {
		log.Fatal(err)
	}
}
