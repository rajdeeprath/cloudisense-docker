# Use a minimal base image
FROM python:3.8-slim

# Set working directory
WORKDIR /app

# Install necessary packages with minimal dependencies
RUN apt-get update && apt-get install -y --no-install-recommends git unzip wget \
    && rm -rf /var/lib/apt/lists/*

# Clone the installer repository and grant execution permissions
RUN git clone https://github.com/rajdeeprath/cloudisense-installer /cloudisense-installer && \
    chmod +x /cloudisense-installer/*.sh

# Run the core installation with the environment variable set
RUN PROGRAM_INSTALL_AS_SERVICE=false /cloudisense-installer/install.sh -i -c && \
    /cloudisense-installer/install.sh -i -m "shell,logmonitor,reaction,system,filesystem,rpcgateway,security"

# Remove the installer after installation (in a separate layer)
RUN rm -rf /cloudisense-installer


# Download and extract Apache Tomcat 7.0.32 directly into /root/filesystem
RUN set -e && wget -q -O /tmp/apache-tomcat-7.0.32.zip https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.32/bin/apache-tomcat-7.0.32.zip && \
    mkdir -p /root/filesystem && \
    unzip -q /tmp/apache-tomcat-7.0.32.zip -d /tmp/ && \
    mv /tmp/apache-tomcat-7.0.32/* /root/filesystem/ && \
    rm -rf /tmp/apache-tomcat-7.0.32 /tmp/apache-tomcat-7.0.32.zip  # Cleanup extracted folder and zip file


# Create the log directory before log generation starts
RUN mkdir -p /root/filesystem/logs && touch /root/filesystem/logs/fakelog.log

# Create and set up a fake log generator script (No console output)
RUN echo '#!/bin/bash' > /root/fake_log_generator.sh && \
    echo 'mkdir -p /root/filesystem/logs' >> /root/fake_log_generator.sh && \
    echo 'touch /root/filesystem/logs/fakelog.log' >> /root/fake_log_generator.sh && \
    echo 'while true; do' >> /root/fake_log_generator.sh && \
    echo '  log_time=$(date)' >> /root/fake_log_generator.sh && \
    echo '  log_level=$(shuf -e INFO WARN DEBUG ERROR -n 1)' >> /root/fake_log_generator.sh && \
    echo '  log_msg="$log_level - Fake log message $(shuf -i 1-100 -n 1)"' >> /root/fake_log_generator.sh && \
    echo '  echo "$log_time - $log_msg" >> /root/filesystem/logs/fakelog.log' >> /root/fake_log_generator.sh && \
    echo '  sleep $(shuf -i 1-5 -n 1)' >> /root/fake_log_generator.sh && \
    echo 'done' >> /root/fake_log_generator.sh && \
    chmod +x /root/fake_log_generator.sh


# Set additional environment variables
ENV ENV_BIND_HOST=0.0.0.0
ENV ENV_LOG_TARGETS='[{"enabled": true, "name": "fakelog.log", "log_file_path": "/root/filesystem/logs/fakelog.log"}]'
ENV ENV_ACCESSIBLE_PATHS="[\"/root/filesystem\"]"
ENV ENV_DOWNLOADABLE_PATHS="[\"/root/filesystem\"]"

# Expose port 8000
EXPOSE 8000

# Run the log generator in the background & Start Cloudisense
CMD ["/bin/bash", "-c", "/root/fake_log_generator.sh & exec /root/virtualenvs/cloudisense/bin/python3.8 /root/cloudisense/run.py"]
