all: setup
	$(MAKE) -C terraform

setup:
	bundle install
	$(MAKE) -C packer

clean:
	$(MAKE) -C terraform clean

distclean:
	$(MAKE) -C packer clean

.PHONY: all setup clean distclean
