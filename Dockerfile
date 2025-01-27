# Use a minimal base image for the builder stage
FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal as builder

# Install necessary tools
RUN microdnf install -y wget gnupg2 && \
    microdnf clean all

# Determine the architecture and download the RPM and its signature
RUN MP_ARCH=$(uname -p | sed 's/aarch64/arm64/') && \
    wget -q "https://s3.amazonaws.com/mountpoint-s3-release/latest/${MP_ARCH}/mount-s3.rpm" && \
    wget -q "https://s3.amazonaws.com/mountpoint-s3-release/latest/${MP_ARCH}/mount-s3.rpm.asc" && \
    wget -q https://s3.amazonaws.com/mountpoint-s3-release/public_keys/KEYS

# Import the GPG key and verify the fingerprint
RUN gpg --import KEYS && \
    gpg --fingerprint mountpoint-s3@amazon.com | grep "673F E406 1506 BB46 9A0E  F857 BE39 7A52 B086 DA5A"

# Verify the RPM signature
RUN gpg --verify mount-s3.rpm.asc mount-s3.rpm

# Use a minimal base image for the final stage
FROM public.ecr.aws/amazonlinux/amazonlinux:2023-minimal

# Copy the verified RPM from the builder stage
COPY --from=builder /mount-s3.rpm /mount-s3.rpm

# Install the RPM and clean up
RUN microdnf upgrade -y && \
    microdnf install -y fuse3 shadow-utils && \
    microdnf install -y /mount-s3.rpm && \
    microdnf clean all && \
    rm -f /mount-s3.rpm

# Allow FUSE for all users
RUN echo "user_allow_other" >> /etc/fuse.conf

RUN mkdir -p /mnt/s3

# Set the entrypoint to the mount-s3 command
ENTRYPOINT ["mount-s3", "-f", "${S3_BUCKET}", "/mnt/s3", "--allow-other"]