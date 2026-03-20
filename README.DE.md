# FOSS SmartHome Planner

English: [README.md](README.md)

Start-Repository fuer einen selbst gehosteten FOSS-Smart-Home-Planer.

## Überblick

- Enthaelt die Standard-Basisdateien fuer neue oeffentliche Repositories in diesem Workspace.
- Bringt bereits ein lauffaehiges Docker-Startimage samt `docker compose`-Setup mit.
- Nutzt eine LinuxServer-aehnliche S6-Service-Kette, damit die eigentliche Anwendung spaeter sauber eingebaut werden kann.

## Schnellstart

```bash
cp .env.example .env
mkdir -p secrets
printf '%s' 'change-me' > secrets/planner_admin_password.txt

make build
make start
```

Danach ist der Platzhalter unter `http://127.0.0.1:3000` erreichbar.

## Repository-Struktur

- `app/`: Platzhalter-Weboberflaeche als lauffaehiger Startpunkt
- `defaults/`: Startkonfiguration, die beim ersten Lauf nach `/config` kopiert wird
- `root/`: S6-Overlay-Service-Definitionen
- `docs/`: gemeinsame Betriebs- und Workflow-Hinweise
- `.github/`: Automatisierung und Community-Health-Dateien

## Naechste Schritte

- Die Platzhalter-App durch das echte Frontend/Backend ersetzen.
- Die CI-Workflows an den finalen Technologiestack anpassen.
- Die uebernommenen Dokumente vor dem ersten oeffentlichen Release projektspezifisch nachziehen.
