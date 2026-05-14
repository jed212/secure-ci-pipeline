package handlers

import (
	"encoding/json"
	"net/http"
)

type HealthResponse struct {
	Status string `json:"status"`
}

func HealthHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	if err := json.NewEncoder(w).Encode(HealthResponse{
		Status: "healthy",
	}); err != nil {
		http.Error(w, "failed to encode response", http.StatusInternalServerError)
	}
}
