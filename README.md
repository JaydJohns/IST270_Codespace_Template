# IST270_Codespace_Template

## Part 2: Student Guide (For Your Assignment)

Below is a guide you can follow directly to begin and work with your assignment environment.

### How to Start Your Assignment
1. Navigate to the GitHub repository for this assignment.
2. Click the green **< > Code** button.
3. Select the **Codespaces** tab.
4. Click **Create codespace on main** (or on your assignment branch).
5. Be patient: the first build takes 2–3 minutes. It is installing a full PostgreSQL database server just for you.

### How to Connect to Your Database
Your Codespace is a full VS Code environment with the PostgreSQL extension pre-installed.

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
