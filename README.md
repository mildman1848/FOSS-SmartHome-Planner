# FOSS SmartHome Planner

Deutsch: [README.DE.md](README.DE.md)

Starter repository for a self-hosted FOSS Smart Home planning service.

## Overview

- Includes the required public-repository baseline for this workspace.
- Ships with a runnable Docker starter image and `docker compose` setup.
- Uses a LinuxServer-style S6 service chain so the real application can be added incrementally.

## Quick Start

```bash
cp .env.example .env
mkdir -p secrets
printf '%s' 'change-me' > secrets/planner_admin_password.txt

make build
make start
```

Open `http://127.0.0.1:3000` after startup.

## Repository Layout

- `app/`: placeholder web UI that proves the container boots correctly
- `defaults/`: starter configuration copied into `/config` on first run
- `root/`: S6 overlay service definitions
- `docs/`: shared operational and workflow notes
- `.github/`: repository automation and community health files

## Next Steps

- Replace the placeholder HTML app with the real planner frontend/backend.
- Adapt the CI workflow to the final application stack once it is chosen.
- Review the copied docs for project-specific wording before the first public release.
