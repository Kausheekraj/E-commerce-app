FROM ubuntu:latest

# Copy your script
COPY install.sh /usr/local/bin/install.sh

# Make it executable and install prerequisites
RUN chmod +x /usr/local/bin/install.sh && \
  rm -rf /var/lib/apt/lists/*

# Run your script
RUN /usr/local/bin/install.sh

CMD ["bash"]
