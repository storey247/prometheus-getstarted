package main

import (
	"fmt"
	"net/http"

	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promauto"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {

		http.Handle("/hello", promhttp.InstrumentHandlerDuration(
			promauto.NewHistogramVec(
					prometheus.HistogramOpts{
						Name: "hello_request_duration_seconds",
						Help: "hello-world request duration",
					},
					[]string{"code"},
			), http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
				fmt.Fprint(w, "Hello, world!")
			}),
		))

        http.Handle("/metrics", promhttp.Handler())
        http.ListenAndServe(":2112", nil)
}