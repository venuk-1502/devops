clean:
	@rm -rf .terraform

dev-apply: clean ## Create Dev Environment
	@terraform init -backend-config=env/dev-backend.tfvars
	@terraform apply -auto-approve -var-file=env/dev.tfvars

prod-apply: clean ## Create Prod Environment
	@terraform init -backend-config=env/prod-backend.tfvars
	@terraform apply -auto-approve -var-file=env/prod.tfvars

dev-destroy: clean ## Destroy Dev Environment
	@terraform init -backend-config=env/dev-backend.tfvars
	@terraform destroy -auto-approve -var-file=env/dev.tfvars

prod-destroy: clean ## Destroy Prod Environment
	@terraform init -backend-config=env/prod-backend.tfvars
	@terraform destory -auto-approve -var-file=env/prod.tfvars