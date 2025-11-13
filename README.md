# Database Course - SQL Assignment Environment

## Getting Started
1. Open this repository in Codespace (green "Code" button → Codespaces tab)
2. Wait for the container to build (first time takes ~2 min)
3. PostgreSQL starts automatically

## Connect to PostgreSQL
In the terminal:
```bash
psql -U postgres
```

Password: `postgres`

## Run Assignment Files
```bash
psql -U postgres -f assignment1.sql
```

## Quick Reference
- List databases: `\l`
- Connect to database: `\c database_name`
- List tables: `\dt`
- Exit: `\q`