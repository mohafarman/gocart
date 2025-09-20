package main

import "net/http"

func (app *application) logError(r *http.Request, err error) {
	app.logger.Error(err.Error(), "request_metod", r.Method, "request_url", r.URL.String())
}

func (app *application) responseError(w http.ResponseWriter, r *http.Request, status int, message any) {
	env := envelope{"error": message}

	err := app.writeJSON(w, status, env, nil)
	if err != nil {
		app.logError(r, err)
		w.WriteHeader(http.StatusInternalServerError)
	}
}

func (app *application) responseNotFound(w http.ResponseWriter, r *http.Request) {
	msg := "the requested resource could not be found"
	app.responseError(w, r, http.StatusNotFound, msg)
}
