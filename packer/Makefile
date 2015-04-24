all: ami.stamp
ami.stamp:
	packer build r-install.json | tee packer_log.tmp
	tail -1 packer_log.tmp | awk '{ print $$2 }' > ami.stamp.tmp
	mv ami.stamp.tmp ami.stamp

clean:
	bundle exec ruby deregister_image.rb `cat ami.stamp`
	rm -f *.tmp ami.stamp

.PHONY: all clean
