all: setup.stamp
	$(MAKE) -C terraform

setup: setup.stamp
setup.stamp:
	bundle install --path vendor/bundle
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

ODGS := $(wildcard draw/*.odg)
PNGS := $(patsubst %.odg,%.png,${ODGS})

figure: ${PNGS}

%.png: %.odg
	unoconv -n -f png -o unoconv_tmp $< 2> /dev/null   || \
	  unoconv -f png -o unoconv_tmp $<                 || \
	  unoconv -n -f png -o unoconv_tmp $< 2> /dev/null || \
	  unoconv -f png -o unoconv_tmp $<
	convert -resize 600x unoconv_tmp.png $@
	rm -f unoconv_tmp.png

.PHONY: all setup login clean distclean figure
