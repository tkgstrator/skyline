# TODO (Khangaroo): Make this process a lot less hacky (no, export did not work)
# See MakefileNSO

.PHONY: all clean skyline send

PYTHON := python3
ifeq (, $(shell which python3))
	# if no python3 alias, fall back to `python` and hope it's py3
	PYTHON   := python
endif

NAME 			:= $(shell basename $(CURDIR))
NAME_LOWER		:= $(shell echo $(NAME) | tr A-Z a-z)
TID				:= 0100ABF008968000
CODE_NAME		:= sword
SUBSDK_NAME		:= subsdk2

SCRIPTS_DIR		:= scripts
BUILD_DIR 		:= build

SEND_PATCH		:= $(SCRIPTS_DIR)/send_over_ftp.py

MAKE_NSO		:= MakefileNSO

all: skyline $(CODE_NAME).npdm

skyline:
	$(MAKE) all -f $(MAKE_NSO) BUILD=$(BUILD_DIR) TARGET=$(NAME)

$(CODE_NAME).npdm: $(CODE_NAME).json
	npdmtool $(CODE_NAME).json $(CODE_NAME).npdm

send: all
	$(PYTHON) $(SEND_PATCH) $(IP) $(TID) $(CODE_NAME) $(SUBSDK_NAME)

clean:
	$(MAKE) clean -f $(MAKE_NSO)
	@rm $(CODE_NAME).npdm
