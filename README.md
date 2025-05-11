# Polytopia

> [!WARNING]  
> This repository has been archived in favor of <https://github.com/Reed-CSTAR/reednet>

***

This repository provides a couple things:

### Nix dev shells

These are premade environments that provide all the software used in CS classes. On the CS department machines, you can access them via
```bash
nix develop polytopia#cs221
```
On your own machine (if Nix is installed), you can access them via
```bash
nix develop github:Samasaur1/polytopia#cs384
```

At the time of writing, there are three dev shells:
- cs221
- cs378
- cs384

You can check the dev shells that exist now either by looking in the `devShells` directory or running `nix flake show polytopia`.

##### Upgrades

```bash
nix flake update --commit-lock-file
```

There is a GitHub Action set up that automatically updates the flake inputs weekly, so the only action necessary is to merge this PR.

Perhaps we only want to update dev shells in between semesters, so that they are consistent throughout a class?

### Ansible configuration

##### Running the playbook

1. Install Ansible (you can launch a subshell that provides Ansible via `nix develop`)
2. Run the playbook

    ```bash
    ansible-playbook -i inventory.ini playbook.yaml -K
    ```

    If you're using the dev shell:
    ```bash
    poly-run-ansible
    ```

    Note that you need SSH host configurations for all machines, since they are defined in the inventory without their FQDNs

##### Adding users

1. Generate a temporary password (let's say it's `correct horse battery staple`)
2. Install `mkpasswd` (you can launch a subshell that provides `mkpasswd` via `nix develop`)
3. Hash the temporary password:

    ```bash
    mkpasswd --method=sha-512
    ```

    If you're using the dev shell:
    ```bash
    poly-hash-password
    ```

    Using our example, this gives `$6$e0A7MR6aAnL3r9Y5$WevmaiUlUo6p67OErBd8.krTCTg/36EnNrpj8zUJKNWwIn3L7MqSmc3rOPupmajxJQ9z3N9Hsg7x9GaZfeVZr.`
4. Add user and group entries to `users.yaml`

    ```yaml
    - name: Synchronize group 'sam'
      become: true
      ansible.builtin.group:
        name: sam
        state: present
        system: false
    - name: Synchronize user 'sam'
      become: true
      ansible.builtin.user:
        append: false
        comment: Samasaur1,,,
        create_home: true
        generate_ssh_key: false
        group: sam
        groups: users
        name: sam
        password: '$6$e0A7MR6aAnL3r9Y5$WevmaiUlUo6p67OErBd8.krTCTg/36EnNrpj8zUJKNWwIn3L7MqSmc3rOPupmajxJQ9z3N9Hsg7x9GaZfeVZr.'
        shell: '/usr/bin/bash'
        state: present
        system: false
        update_password: on_create
    ```

5. [Run the Ansible playbook](#running-the-playbook)
