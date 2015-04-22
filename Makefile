all: setup
setup:
	$(MAKE) -C packer

distclean:
	$(MAKE) -C packer clean

.PHONY: all setup clean distclean
