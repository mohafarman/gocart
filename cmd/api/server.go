package main

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"
)

func (app *application) serve() error {
	server := http.Server{
		Addr:         fmt.Sprintf(":%d", app.config.port),
		ReadTimeout:  5 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  60 * time.Second,
		Handler:      app.routes(),
		// Add ErrorLog
	}

	// Graceful shutdown
	// Channel to receive any errors returned by Shutdown()
	shutdownError := make(chan error)

	go func() {
		// Channel to carry one os.Signal
		quit := make(chan os.Signal, 1)

		// Other signals will retain their default behavior
		signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)

		// Read signal from the quit channel
		// Code is now blocked until a signal is received

		s := <-quit

		app.logger.Info("Shutting down server gracefully...", "signal", s.String())

		ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
		defer cancel()

		err := server.Shutdown(ctx)
		if err != nil {
			// Only send on the shutdownError channel if there's an error
			shutdownError <- err
		}

		app.logger.Info("Completing background tasks...")

		shutdownError <- nil
	}()

	app.logger.Info("Starting server", "port", app.config.port)

	// Calling Shutdown() will cause server.ListenAndServer() to return http.ErrServerClosed
	err := server.ListenAndServe()
	if err != nil {
		if !errors.Is(err, http.ErrServerClosed) {
			return err
		}
	}

	err = <-shutdownError
	if err != nil {
		return err
	}

	app.logger.Info("Server stopped.", "address", server.Addr)

	return nil
}
