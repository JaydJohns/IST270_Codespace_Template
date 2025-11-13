# IST270_Codespace_Template

## Part 2: Student Guide (For Your Assignment)

Below is a guide you can follow directly to begin and work with your assignment environment.

### How to Start Your Assignment
1. Navigate to the GitHub repository for this assignment.
2. Click the green **< > Code** button.
3. Select the **Codespaces** tab.
4. Click **Create codespace on main** (or on your assignment branch).
5. Be patient: the first build takes 2–3 minutes while the container image downloads.
6. After the Codespace opens, run the manual bootstrap script from the built-in terminal:

```bash
bash scripts/bootstrap-postgres.sh
```

Follow the prompts; the script installs PostgreSQL, starts the service, and ensures the VS Code PostgreSQL extension is available.

### How to Connect to Your Database
Your Codespace is a full VS Code environment with the PostgreSQL extension (installed by the bootstrap script) available.

1. After the Codespace loads, wait ~15–30 seconds for the database service to finish starting in the background.
2. In the VS Code Activity Bar (far left), click the PostgreSQL (elephant) icon.
3. In the PostgreSQL extension panel, click the **+** (plus) icon to add a new connection.
4. A sequence of input boxes will appear at the top. Enter the following values (press Enter after each):
	 - **Hostname:** `localhost`
	 - **Database:** `appdb`
	 - **User:** `postgres`
	 - **Password:** `postgres`
	 - **Port:** `5432`
	 - **Show just this database?** Either choice (Yes/No) is fine.
5. After confirmation, you should see `appdb` in the side panel. You can right-click the database (or any table) to run queries, or create a new `.sql` file to write queries manually.

### How to Run SQL Files
1. Create a new file, e.g. `query.sql`.
2. Write your SQL, for example: `CREATE TABLE test (id INT);`
3. Highlight the SQL you want to run.
4. Right-click and choose **Execute Query**.
5. View results in the output tab that appears.

### Persistence
Your database data is persistent across sessions. If you stop your Codespace and return later, your tables and data will still be there.

### Manual Bootstrap Script Details
- Script path: `scripts/bootstrap-postgres.sh`
- Re-run it anytime you need to reinstall PostgreSQL or reset the default credentials (`postgres` / `postgres`, database `appdb`).
- The script is idempotent: it skips work that has already been completed but will always ensure the database service is running before it exits.
