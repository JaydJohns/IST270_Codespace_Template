# Start from a base Microsoft-provided image
FROM mcr.microsoft.com/devcontainers/universal:2

# --- ADD THIS LINE ---
# Create the workspace directory in advance
# This prevents a race condition on startup
RUN mkdir -p /workspace

# You can add any other tools your students need here.
# For example, to install Python libraries:
# RUN pip3 install pandas numpy
