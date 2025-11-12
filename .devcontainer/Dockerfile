# Start from a base Microsoft-provided image
FROM mcr.microsoft.com/devcontainers/universal:2

# --- UPDATED FIX ---
# Create the directory AND change ownership to the non-root user
# $_REMOTE_USER is a built-in variable in this image (usually 'vscode')
RUN mkdir -p /workspace \
    && chown -R $_REMOTE_USER:$_REMOTE_USER /workspace

# You can add any other tools your students need here.
# For example, to install Python libraries:
# RUN pip3 install pandas numpy
