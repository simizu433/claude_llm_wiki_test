FROM node:22-bookworm-slim

ARG USERNAME=devuser
ARG USER_UID=1000
ARG USER_GID=1000

ENV DEBIAN_FRONTEND=noninteractive

USER root

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    less \
    procps \
    vim \
  && rm -rf /var/lib/apt/lists/*

# Create or reuse a real Linux user for VS Code Dev Containers.
# node:22 images already have a `node` user with UID 1000, so we rename/reuse it
# when the host UID is 1000. This avoids "unable to find user devuser" errors.
RUN set -eux; \
  if getent group "${USER_GID}" >/dev/null; then \
    GROUP_NAME="$(getent group "${USER_GID}" | cut -d: -f1)"; \
  else \
    groupadd --gid "${USER_GID}" "${USERNAME}"; \
    GROUP_NAME="${USERNAME}"; \
  fi; \
  if id -u "${USERNAME}" >/dev/null 2>&1; then \
    usermod --uid "${USER_UID}" --gid "${USER_GID}" "${USERNAME}"; \
  elif getent passwd "${USER_UID}" >/dev/null; then \
    EXISTING_USER="$(getent passwd "${USER_UID}" | cut -d: -f1)"; \
    usermod -l "${USERNAME}" "${EXISTING_USER}"; \
    usermod --gid "${USER_GID}" "${USERNAME}"; \
    mkdir -p "/home/${USERNAME}"; \
    usermod -d "/home/${USERNAME}" "${USERNAME}"; \
  else \
    useradd --uid "${USER_UID}" --gid "${USER_GID}" -m -s /bin/bash "${USERNAME}"; \
  fi; \
  mkdir -p "/home/${USERNAME}" /workspace /workspace/.npm-global /workspace/wiki /workspace/wiki/assets /workspace/wiki/sources; \
  chown -R "${USER_UID}:${USER_GID}" "/home/${USERNAME}" /workspace

ENV HOME=/home/${USERNAME}
ENV NPM_CONFIG_PREFIX=/workspace/.npm-global
ENV PATH=/workspace/.npm-global/bin:${PATH}

WORKDIR /workspace
USER ${USERNAME}

# npm / yarn / pnpm registry guard for Takumi Guard
RUN npm config set registry https://npm.flatt.tech/

CMD ["bash"]
