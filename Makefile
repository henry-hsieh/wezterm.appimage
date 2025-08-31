prefix ?= /usr/local/
nowayland ?=

.PHONY: all clean build submodule_init docker_build install

DOCKER_CMD := docker run -t \
							--privileged \
							-e TARGET_UID=$(shell id -u) \
							-e TARGET_GID=$(shell id -g) \
							-e TARGET_USER=$(shell id -un) \
							-v $(CURDIR):$(CURDIR) \
							-w $(CURDIR)/wezterm \
							wezterm

ifdef nowayland
	NO_WAYLAND := NoWayland-
	CARGO_COMMAND := cargo build --quiet --release
	APPIMAGE_COMMAND := cp ./ci/appimage.sh ./ci/appimage-nowayland.sh && \
											sed -i 's|AppDir|&-NoWayland|' ./ci/appimage-nowayland.sh && \
											./ci/appimage-nowayland.sh
else
	NO_WAYLAND :=
	CARGO_COMMAND := cargo build --quiet --release
	APPIMAGE_COMMAND := ./ci/appimage.sh
endif
TAG_NAME ?= $(shell git -C $(CURDIR)/wezterm -c "core.abbrev=8" show -s "--format=%cd-%h" "--date=format:%Y%m%d-%H%M%S")
OLD_TAG := $(TAG_NAME)
TAG_NAME := $(NO_WAYLAND)$(TAG_NAME)
distro := $(shell $(DOCKER_CMD) bash -c 'lsb_release -is 2>/dev/null || sh -c "source /etc/os-release && echo \$NAME"')
distver := $(shell $(DOCKER_CMD) bash -c 'lsb_release -rs 2>/dev/null || sh -c "source /etc/os-release && echo \$VERSION_ID"')
OUT := wezterm/WezTerm-$(TAG_NAME)-$(distro)$(distver).AppImage

all: $(OUT)

$(OUT): build
	$(DOCKER_CMD) \
	bash -c "export TAG_NAME=$(TAG_NAME); $(APPIMAGE_COMMAND)"

build: | submodule_init
	$(DOCKER_CMD) \
	$(CARGO_COMMAND)

submodule_init:
	@git submodule update --init --recursive > /dev/null

docker_build:
	docker build -t wezterm $(CURDIR)

clean:
	rm -rf wezterm/target wezterm/AppDir* wezterm/*.AppImage wezterm/*.zsync
