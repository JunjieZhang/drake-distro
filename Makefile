# Basic collection makefile distributed with pods version: 12.11.14

# get a list of subdirs to build by reading tobuild.txt
SUBDIRS:=$(shell grep -v "^\#" tobuild.txt)
TESTDIRS:=$(shell grep -v "^\#" totest.txt)

# Figure out where to build the software.
#   Use BUILD_PREFIX if it was passed in.
#   If not, search up to three parent directories for a 'build' directory.
#   Otherwise, use ./build.
ifeq "$(BUILD_PREFIX)" ""
BUILD_PREFIX=$(shell for pfx in ./ .. ../.. ../../..; do d=`pwd`/$$pfx/build; \
               if [ -d "$$d" ]; then echo $$d; exit 0; fi; done; echo `pwd`/build)
endif

export BUILD_PREFIX

# build quietly by default.  For a verbose build, run "make VERBOSE=1"
$(VERBOSE).SILENT:

all: 
	@[ -d "$(BUILD_PREFIX)" ] || mkdir -p "$(BUILD_PREFIX)" || exit 1
	@for subdir in $(SUBDIRS); do \
		echo "\n-------------------------------------------"; \
		echo "-- $$subdir"; \
		echo "-------------------------------------------"; \
		$(MAKE) -C $$subdir all || exit 2; \
	done
	@# Place additional commands here if you have any

test: all
	@[ -d "$(BUILD_PREFIX)" ] || mkdir -p "$(BUILD_PREFIX)" || exit 1
	@for subdir in $(TESTDIRS); do \
		echo "\n-------------------------------------------"; \
		echo "-- $$subdir"; \
		echo "-------------------------------------------"; \
		$(MAKE) -C $$subdir test || exit 2; \
	done
	@# Place additional commands here if you have any

clean:
	@for subdir in $(SUBDIRS); do \
		echo "\n-------------------------------------------"; \
		echo "-- $$subdir"; \
		echo "-------------------------------------------"; \
		$(MAKE) -C $$subdir clean; \
	done
	@# Place additional commands here if you have any

# other (custom) targets are passed through to the cmake-generated Makefile 
%::
	@for subdir in $(SUBDIRS); do \
		echo "\n-------------------------------------------"; \
		echo "-- $$subdir"; \
		echo "-------------------------------------------"; \
		$(MAKE) -C $$subdir $@; \
	done
	@# Place additional commands here if you have any

install_prereqs_homebrew:
	brew install cmake gtk+
	@for subdir in $(SUBDIRS); do \
		$(MAKE) -C $$subdir $@; \
	done

install_prereqs_macports:
	port install cmake gtk2
	@for subdir in $(SUBDIRS); do \
		$(MAKE) -C $$subdir $@; \
	done

install_prereqs_ubuntu:
	apt-get install cmake openjdk-6-jdk build-essential
	@for subdir in $(SUBDIRS); do \
		$(MAKE) -C $$subdir $@; \
	done

install_prereqs_cygwin:
	cygwin-setup -q -P pkg-config
	@for subdir in $(SUBDIRS); do \
		$(MAKE) -C $$subdir $@; \
	done

release_filelist:
	find * -maxdepth 0 -type f | grep -v ".zip"
	find build -type f
	@for subdir in $(SUBDIRS); do \
		$(MAKE) -C $$subdir $@ | sed -e "s/^/$$subdir\//" || true; \
	done

release_zip:
	zip drake-distro `$(MAKE) release_filelist`
