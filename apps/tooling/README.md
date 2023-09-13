# Tooling to support the stack

This terraform chart contains supporting tooling for interacting with 
the stack as an engineer or tester.

## Running ansible on the tooling output

To get ansible out of the tooling chart, first run the terraform chart:
(see more about the stack command below)
```
$/> ./stack apps/tooling apply -auto-approve
```
And then use the output hosts file (and optionally the config file)
```
$/> ANSIBLE_CONFIG=apps/tooling/ansible.cfg ansible --inventory=apps/tooling/hosts.ini all -m ansible.builtin.setup
```
The above ansible built in just gathers facts. The following command could be used to ssh into a machine:
```
$/> ansible-console --inventory=apps/tooling/hosts.ini {some host here}
Welcome to the ansible console. Type help or ? to list commands.

james@jntest-AMan-0 (1)[f:5]$ exec ls -la
jntest-AMan-0 | CHANGED | rc=0 >>
total 32
drwxr-xr-x 5 ubuntu ubuntu 4096 Oct  5 18:08 .
drwxr-xr-x 3 root   root   4096 Oct  5 15:11 ..
drwx------ 3 ubuntu ubuntu 4096 Oct  5 18:08 .ansible
-rw-r--r-- 1 ubuntu ubuntu  220 Feb 25  2020 .bash_logout
-rw-r--r-- 1 ubuntu ubuntu 3771 Feb 25  2020 .bashrc
drwx------ 2 ubuntu ubuntu 4096 Oct  5 15:13 .cache
-rw-r--r-- 1 ubuntu ubuntu  807 Feb 25  2020 .profile
drwx------ 2 ubuntu ubuntu 4096 Oct  5 15:11 .ssh
-rw-r--r-- 1 ubuntu ubuntu    0 Oct  5 15:13 .sudo_as_admin_successful
```
