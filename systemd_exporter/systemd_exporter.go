package main

import (
	"./exporter"
	"github.com/kawamuray/prometheus-exporter-harness/harness"
)

func main() {
	opts := harness.NewExporterOpts("systemd_exporter", exporter.Version)
	opts.Usage = "[OPTIONS] HTTP_ENDPOINT CONFIG_PATH"
	opts.Init = exporter.Init
	harness.Main(opts)
}
