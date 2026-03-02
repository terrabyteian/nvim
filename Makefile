# Run from the repo root:
#   make ubuntu            build Ubuntu image (native arch)
#   make debian            build Debian image (native arch)
#   make ubuntu-amd64      build Ubuntu linux/amd64  (x86_64)
#   make ubuntu-arm64      build Ubuntu linux/arm64  (aarch64)
#   make debian-amd64      build Debian linux/amd64
#   make debian-arm64      build Debian linux/arm64
#
#   make shell-<target>    build (if needed) then drop into interactive shell
#   make test-<target>     build (if needed) then run healthcheck and print results
#   make test-all          run healthcheck on all four arch-specific images
#   make all               build all four arch-specific images
#   make clean             remove all test images

HEALTHCHECK = $(CURDIR)/docker/healthcheck.sh

.PHONY: all ubuntu debian \
        ubuntu-amd64 ubuntu-arm64 debian-amd64 debian-arm64 \
        shell-ubuntu shell-debian \
        shell-ubuntu-amd64 shell-ubuntu-arm64 \
        shell-debian-amd64 shell-debian-arm64 \
        test-ubuntu test-debian \
        test-ubuntu-amd64 test-ubuntu-arm64 \
        test-debian-amd64 test-debian-arm64 \
        test-all clean

# ── Native arch (builds for whatever Docker defaults to) ─────────────────────

ubuntu:
	docker build -f docker/Dockerfile.ubuntu -t nvim-test-ubuntu .

debian:
	docker build -f docker/Dockerfile.debian -t nvim-test-debian .

shell-ubuntu: ubuntu
	docker run --rm -it nvim-test-ubuntu

shell-debian: debian
	docker run --rm -it nvim-test-debian

# ── Explicit amd64 (x86_64) ──────────────────────────────────────────────────

ubuntu-amd64:
	docker build --platform linux/amd64 -f docker/Dockerfile.ubuntu -t nvim-test-ubuntu-amd64 .

debian-amd64:
	docker build --platform linux/amd64 -f docker/Dockerfile.debian -t nvim-test-debian-amd64 .

shell-ubuntu-amd64: ubuntu-amd64
	docker run --rm -it --platform linux/amd64 nvim-test-ubuntu-amd64

shell-debian-amd64: debian-amd64
	docker run --rm -it --platform linux/amd64 nvim-test-debian-amd64

# ── Explicit arm64 (aarch64) ─────────────────────────────────────────────────

ubuntu-arm64:
	docker build --platform linux/arm64 -f docker/Dockerfile.ubuntu -t nvim-test-ubuntu-arm64 .

debian-arm64:
	docker build --platform linux/arm64 -f docker/Dockerfile.debian -t nvim-test-debian-arm64 .

shell-ubuntu-arm64: ubuntu-arm64
	docker run --rm -it --platform linux/arm64 nvim-test-ubuntu-arm64

shell-debian-arm64: debian-arm64
	docker run --rm -it --platform linux/arm64 nvim-test-debian-arm64

# ── Tests (build + run healthcheck non-interactively) ────────────────────────

test-ubuntu: ubuntu
	docker run --rm -v $(HEALTHCHECK):/healthcheck.sh:ro nvim-test-ubuntu bash /healthcheck.sh

test-debian: debian
	docker run --rm -v $(HEALTHCHECK):/healthcheck.sh:ro nvim-test-debian bash /healthcheck.sh

test-ubuntu-amd64: ubuntu-amd64
	docker run --rm --platform linux/amd64 -v $(HEALTHCHECK):/healthcheck.sh:ro nvim-test-ubuntu-amd64 bash /healthcheck.sh

test-ubuntu-arm64: ubuntu-arm64
	docker run --rm --platform linux/arm64 -v $(HEALTHCHECK):/healthcheck.sh:ro nvim-test-ubuntu-arm64 bash /healthcheck.sh

test-debian-amd64: debian-amd64
	docker run --rm --platform linux/amd64 -v $(HEALTHCHECK):/healthcheck.sh:ro nvim-test-debian-amd64 bash /healthcheck.sh

test-debian-arm64: debian-arm64
	docker run --rm --platform linux/arm64 -v $(HEALTHCHECK):/healthcheck.sh:ro nvim-test-debian-arm64 bash /healthcheck.sh

test-all: test-ubuntu-amd64 test-ubuntu-arm64 test-debian-amd64 test-debian-arm64

# ── Bulk ─────────────────────────────────────────────────────────────────────

all: ubuntu-amd64 ubuntu-arm64 debian-amd64 debian-arm64

clean:
	-docker rmi nvim-test-ubuntu nvim-test-debian \
	            nvim-test-ubuntu-amd64 nvim-test-ubuntu-arm64 \
	            nvim-test-debian-amd64 nvim-test-debian-arm64 2>/dev/null
