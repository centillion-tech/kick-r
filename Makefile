all: setup.stamp
	$(MAKE) -C terraform

setup: setup.stamp
setup.stamp:
	bundle install
	$(MAKE) -C packer
	touch setup.stamp

login: setup.stamp
	$(MAKE) -C terraform login

ssh-config: setup.stamp
	@$(MAKE) -C terraform --quiet ssh-config

job: setup.stamp
	$(MAKE) -C terraform job

clean:
	$(MAKE) -C terraform clean

distclean: clean
	$(MAKE) -C packer clean
	rm -f *.stamp

.PHONY: all setup login clean distclean
