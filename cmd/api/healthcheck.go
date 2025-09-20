package main

import "net/http"

func (app *application) healthCheckHandler(w http.ResponseWriter, r *http.Request) {
	env := envelope{
		"status": "available",
	}

	err := app.writeJSON(w, http.StatusOK, env, nil)
	if err != nil {
		app.logger.Error("Internal server error. Could not write json", "internal error message", err.Error())
		app.responseError(w, r, http.StatusInternalServerError, err)
	}
}
