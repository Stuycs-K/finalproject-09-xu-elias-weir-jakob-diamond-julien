.PHONY: variable_change function_pointing working_demo


variable_change: cccchanges
	@./cccchanges

cccchanges: 
	@gcc changing_variable.c -o cccchanges -zexecstack -fno-stack-protector

# example args -> sigmasigma
working_demo: working
	@./working $(ARGS)

working: 
	@gcc working_demo.c -o working

function_pointing:
	@gcc function_pointing.c -o functions -zexecstack -fno-stack-protector

deploy_pwfeedback:
	@docker build -t sudo-test pwfeedback
	@docker run -it --rm --tty sudo-test

deploy_loony: 
	@docker build --platform linux/amd64 -t looney docker
	@docker run  --tty --rm \
           -it looney /bin/bash