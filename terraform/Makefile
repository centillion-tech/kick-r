AMI_STAMP := ../packer/ami.stamp
PEM := kick-r.pem
KEYNAME := kick-r
TERRAFORM_OPT := -var 'key_path=${PEM}' -var 'key_name=${KEYNAME}' -var aws_ami=`cat ${AMI_STAMP}`

all: apply address.stamp

address.stamp:
	terraform show | grep public_dns | awk '{ print $$3 }' > $@

clean: destroy
	rm -f ${PEM}
	bundle exec ruby delete_key_pair.rb ${KEYNAME}

login: all
	ssh -i ${PEM} ubuntu@`cat address.stamp`

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
