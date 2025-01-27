# Stage 1: Download & verify mount-s3
FROM alpine:3.18 AS builder

RUN apk add --no-cache wget gnupg
RUN MP_ARCH=$(uname -m | sed s/aarch64/arm64/ | sed s/x86_64/amd64/) && \
    wget -q "https://s3.amazonaws.com/mountpoint-s3-release/latest/$MP_ARCH/mount-s3.rpm" && \
    wget -q "https://s3.amazonaws.com/mountpoint-s3-release/latest/$MP_ARCH/mount-s3.rpm.asc" && \
    wget -q https://s3.amazonaws.com/mountpoint-s3-release/public_keys/KEYS && \
    gpg --import KEYS && \
    gpg --batch --verify mount-s3.rpm.asc mount-s3.rpm || { echo "GPG verification failed"; exit 1; }

# Stage 2: Install
FROM alpine:3.18
RUN apk add --no-cache fuse rpm alien
COPY --from=builder /mount-s3.rpm /mount-s3.rpm
RUN alien -i /mount-s3.rpm && rm /mount-s3.rpm && \
    echo "user_allow_other" >> /etc/fuse.conf && \
    mkdir -p /mnt/s3

CMD ["mount-s3", "-f", "/mnt/s3"]