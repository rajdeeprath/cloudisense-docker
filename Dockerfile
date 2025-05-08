# Use a minimal base image
FROM python:3.9-slim

# build argument without a default -> installer will find out default on s3
ARG CLOUDISENSE_VERSION=
ENV CLOUDISENSE_VERSION=${CLOUDISENSE_VERSION}
ENV PROGRAM_INSTALL_AS_SERVICE=false


# Set working directory
WORKDIR /app

# Install only git, clone the repository, run the installer, and clean up
RUN apt-get update && apt-get install -y --no-install-recommends git curl && \
    git clone --branch feature/version_builds https://github.com/rajdeeprath/cloudisense-installer /cloudisense-installer && \
    chmod +x /cloudisense-installer/*.sh && \
    /cloudisense-installer/install.sh -i -c && \
    /cloudisense-installer/install.sh -i -p "cloudisensedemo" && \
    rm -rf /cloudisense-installer && \
    apt-get remove -y git curl && apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* ~/.cache/pip


# Download and extract Apache Tomcat, then clean up
RUN apt-get update && apt-get install -y --no-install-recommends wget unzip && \
    wget -q -O /tmp/apache-tomcat-7.0.32.zip https://archive.apache.org/dist/tomcat/tomcat-7/v7.0.32/bin/apache-tomcat-7.0.32.zip && \
    mkdir -p /root/filesystem && \
    unzip -q /tmp/apache-tomcat-7.0.32.zip -d /tmp/ && \
    mv /tmp/apache-tomcat-7.0.32/* /root/filesystem/ && \
    rm -rf /tmp/apache-tomcat-7.0.32 /tmp/apache-tomcat-7.0.32.zip && \
    apt-get remove -y wget unzip && apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Ensure log directory exists
RUN mkdir -p /root/filesystem/logs && touch /root/filesystem/logs/fakelog.log

# Create a fake log generator script safely
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

# Expose port 8000
EXPOSE 8000

# Run the log generator in the background & Start Cloudisense
CMD ["/bin/bash", "-c", "/root/fake_log_generator.sh & exec /root/virtualenvs/cloudisense/bin/python /root/cloudisense/run.py"]
