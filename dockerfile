FROM debian:13.2-slim
LABEL maintainer="taufiqpsumarna@gmail.com"

# Build arguments to allow specifying a dotfiles repository and branch
ARG DOTFILES_REPO="https://github.com/taufiqpsumarna/dotfiles.git"
ARG DOTFILES_BRANCH="main"

# Install minimal tools needed to fetch and run dotfiles installers
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
	 git \
	 ca-certificates \
	 curl \
	 make \
 && rm -rf /var/lib/apt/lists/*

# Clone the dotfiles repository (if provided) and run common installer targets
# This will try `install.sh`, then `bootstrap.sh`, then `make install` when present.
RUN if [ -n "$DOTFILES_REPO" ]; then \
		git clone --depth 1 --branch "$DOTFILES_BRANCH" "$DOTFILES_REPO" /tmp/dotfiles || true; \
		if [ -f /tmp/dotfiles/install.sh ]; then sh /tmp/dotfiles/install.sh; \
		elif [ -f /tmp/dotfiles/bootstrap.sh ]; then sh /tmp/dotfiles/bootstrap.sh; \
		elif [ -f /tmp/dotfiles/Makefile ]; then (cd /tmp/dotfiles && make install) || true; \
		fi; \
	 fi

# Clean up the temporary clone to keep the image small
RUN rm -rf /tmp/dotfiles
