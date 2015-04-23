AMI_STAMP := ../packer/ami.stamp
PEM := kick-r.pem
KEYNAME := kick-r
TERRAFORM_OPT := -var 'key_path=${PEM}' -var 'key_name=${KEYNAME}' -var aws_ami=`cat ${AMI_STAMP}`

all: apply
clean: destroy
	rm -f kick-r.pem
	bundle exec ruby delete_key_pair.rb ${KEYNAME}

show:
	terraform $@

plan apply: ${PEM} ${AMI_STAMP}
	terraform $@ ${TERRAFORM_OPT}

plan_destroy: ${PEM} ${AMI_STAMP}
	terraform plan -destroy ${TERRAFORM_OPT}

kick-r.pem:
	bundle exec ruby create_key_pair.rb ${KEYNAME} > $@
	chmod 600 $@

destroy:
	terraform destroy -force ${TERRAFORM_OPT}

.PHONY: all clean show plan apply plan_destroy destroy
