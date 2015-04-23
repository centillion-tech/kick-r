all: setup
	$(MAKE) -C terraform

setup:
	$(MAKE) -C packer
	$(MAKE) -C terraform setup

clean:
	$(MAKE) -C terraform clean

distclean:
	$(MAKE) -C packer clean

.PHONY: all setup clean distclean
