all: setup
	$(MAKE) -C terraform

setup:
	bundle install
	$(MAKE) -C packer

login: all
	$(MAKE) -C terraform login

job: all
	$(MAKE) -C terraform job

clean:
	$(MAKE) -C terraform clean

distclean: clean
	$(MAKE) -C packer clean

.PHONY: all setup login clean distclean
