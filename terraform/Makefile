AMI_STAMP := ../packer/ami.stamp
ADDRESS_STAMP := address.stamp
PEM := kick-r.pem
KEYNAME := kick-r
TERRAFORM_OPT := -var 'key_path=${PEM}' -var 'key_name=${KEYNAME}' -var aws_ami=`cat ${AMI_STAMP}`
SSH := env LC_ALL=en_US.UTF-8 ssh -i ${PEM} ubuntu@`cat ${ADDRESS_STAMP}`
RSYNC := env LC_ALL=en_US.UTF-8 rsync -auzvL -e "ssh -i ${PEM}"
R := # empty

all: ${ADDRESS_STAMP}

${ADDRESS_STAMP}:
	$(MAKE) apply
	terraform show | grep public_ip | head -1 | awk '{ print $$3 }' > $@.tmp
	mv $@.tmp $@

clean: destroy
	rm -f ${PEM} ${ADDRESS_STAMP}
	bundle exec ruby delete_key_pair.rb ${KEYNAME}

login: all
	${SSH}

ssh-config: all
	@echo "Host kick-r"
	@echo "    Hostname `cat ${ADDRESS_STAMP}`"
	@echo "    User ubuntu"
	@echo "    IdentityFile `realpath ${PEM}`"
	@echo "    ForwardX11 yes"
	@echo "    ServerAliveInterval 30"

job: all
ifdef R
	test -f ${R}
	${SSH} mkdir -p kick-r/job
	${RSYNC} `dirname ${R}`/ ubuntu@`cat ${ADDRESS_STAMP}`:~/kick-r/job/`basename ${R}`
	${SSH} "cd kick-r/job/`basename ${R}` && R --vanilla < `basename ${R}`"
	${RSYNC} ubuntu@`cat ${ADDRESS_STAMP}`:~/kick-r/job/`basename ${R}`/ `dirname ${R}`/
	${SSH} rm -rf 'kick-r/job/*'
else
	@echo '*** Need "R" value for location of R script.'
endif

show:
	terraform $@

plan apply: ${PEM} ${AMI_STAMP}
	terraform $@ ${TERRAFORM_OPT}

plan_destroy: ${PEM} ${AMI_STAMP}
	terraform plan -destroy ${TERRAFORM_OPT}

${PEM}:
	bundle exec ruby create_key_pair.rb ${KEYNAME} > $@
	chmod 600 $@

destroy:
	terraform destroy -force ${TERRAFORM_OPT}

.PHONY: all clean login show plan apply plan_destroy destroy
