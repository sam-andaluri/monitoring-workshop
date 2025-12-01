# Makefile for Grafana dashboard management

JSONNET := /usr/local/bin/jsonnet
DASHBOARD_SRC := workshop-dashboard.jsonnet
DASHBOARD_OUT := workshop-dashboard.json
GRAFANA_URL := http://localhost:3000
VENDOR_DIR := vendor

# Grafana password - set via environment or override on command line
# Usage: make deploy GRAFANA_PASSWORD=yourpassword
GRAFANA_PASSWORD ?=

.PHONY: all build deploy clean help

all: build

## Build the dashboard JSON from jsonnet source
build: $(DASHBOARD_OUT)

$(DASHBOARD_OUT): $(DASHBOARD_SRC)
	$(JSONNET) -J $(VENDOR_DIR) $< -o $@

## Deploy dashboard to Grafana (requires GRAFANA_PASSWORD)
deploy: $(DASHBOARD_OUT)
ifndef GRAFANA_PASSWORD
	$(error GRAFANA_PASSWORD is not set. Usage: make deploy GRAFANA_PASSWORD=yourpassword)
endif
	@curl -s -X POST \
		-H 'Content-Type: application/json' \
		-d '{"dashboard": $(shell jq . $(DASHBOARD_OUT)), "overwrite": true}' \
		"http://admin:$(GRAFANA_PASSWORD)@localhost:3000/api/dashboards/db" | jq .

## Build and deploy in one step
all-deploy: build deploy

## Remove generated files
clean:
	rm -f $(DASHBOARD_OUT)

## Show available targets
help:
	@echo "Available targets:"
	@echo "  build   - Compile jsonnet to JSON"
	@echo "  deploy  - Push dashboard to Grafana (requires GRAFANA_PASSWORD)"
	@echo "  clean   - Remove generated files"
	@echo ""
	@echo "Usage examples:"
	@echo "  make build"
	@echo "  make deploy GRAFANA_PASSWORD=mysecretpass"
	@echo "  GRAFANA_PASSWORD=mysecretpass make deploy"