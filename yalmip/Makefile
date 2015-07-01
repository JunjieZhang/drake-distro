
default_target: all

# Figure out where to build the software.
#   Use BUILD_PREFIX if it was passed in.
#   If not, search up to four parent directories for a 'build' directory.
#   Otherwise, use ./build.
ifeq "$(BUILD_PREFIX)" ""
BUILD_PREFIX:=$(shell for pfx in ./ .. ../.. ../../.. ../../../..; do d=`pwd`/$$pfx/build;\
               if [ -d $$d ]; then echo $$d; exit 0; fi; done; echo `pwd`/build)
endif
# create the build directory if needed, and normalize its path name
BUILD_PREFIX:=$(shell mkdir -p $(BUILD_PREFIX) && cd $(BUILD_PREFIX) && echo `pwd`)

# Default to a release build.  If you want to enable debugging flags, run
# "make BUILD_TYPE=Debug"
ifeq "$(BUILD_TYPE)" ""
BUILD_TYPE="Release"
endif

DL_PATH   = http://www.control.isy.liu.se/~johanl/
UNZIP_DIR = yalmip
DL_NAME = YALMIP.zip

all: $(UNZIP_DIR) $(BUILD_PREFIX)/matlab/addpath_yalmip.m $(BUILD_PREFIX)/matlab/rmpath_yalmip.m

$(UNZIP_DIR):
	wget --no-check-certificate $(DL_PATH)/$(DL_NAME) && unzip $(DL_NAME) && rm $(DL_NAME)

$(BUILD_PREFIX)/matlab/addpath_yalmip.m :
	@mkdir -p $(BUILD_PREFIX)/matlab
	echo "Writing $(BUILD_PREFIX)/matlab/addpath_yalmip.m"
	echo "function addpath_yalmip()\n\n \
	  root = fullfile('$(shell pwd)','yalmip');\n \
		addpath(fullfile(root));\n \
		addpath(fullfile(root,'extras'));\n \
		%addpath(fullfile(root,'demos'));\n \
		addpath(fullfile(root,'solvers'));\n \
		addpath(fullfile(root,'modules'));\n \
		addpath(fullfile(root,'modules','parametric'));\n \
		addpath(fullfile(root,'modules','moment'));\n \
		addpath(fullfile(root,'modules','global'));\n \
		addpath(fullfile(root,'modules','sos'));\n \
		addpath(fullfile(root,'operators'));\n \
		end\n \
		\n" \
		> $(BUILD_PREFIX)/matlab/addpath_yalmip.m

$(BUILD_PREFIX)/matlab/rmpath_yalmip.m :
	@mkdir -p $(BUILD_PREFIX)/matlab
	echo "Writing $(BUILD_PREFIX)/matlab/rmpath_yalmip.m"
	echo "function rmpath_yalmip()\n\n \
		root = fullfile('$(shell pwd)','yalmip');\n \
		rmpath(fullfile(root));\n \
		rmpath(fullfile(root,'extras'));\n \
		%rmpath(fullfile(root,'demos'));\n \
		rmpath(fullfile(root,'solvers'));\n \
		rmpath(fullfile(root,'modules'));\n \
		rmpath(fullfile(root,'modules','parametric'));\n \
		rmpath(fullfile(root,'modules','moment'));\n \
		rmpath(fullfile(root,'modules','global'));\n \
		rmpath(fullfile(root,'modules','sos'));\n \
		rmpath(fullfile(root,'operators'));\n \
		end\n \
		\n" \
		> $(BUILD_PREFIX)/matlab/rmpath_yalmip.m

clean:
	-rm $(BUILD_PREFIX)/matlab/*path_yalmip.m

# Default to a less-verbose build.  If you want all the gory compiler output,
# run "make VERBOSE=1"
$(VERBOSE).SILENT:
