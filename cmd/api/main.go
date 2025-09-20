package main

import (
	"log/slog"
	"os"
)

type config struct {
	port int
}

type application struct {
	config config
	logger *slog.Logger
}

func main() {
	var cfg config
	cfg.port = 4000

	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))

	app := application{
		logger: logger,
		config: cfg,
	}

	err := app.serve()
	if err != nil {
		app.logger.Error("Server terminated ungracefully.", "port", app.config.port)
	}
}
