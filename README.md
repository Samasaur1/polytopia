### Adding users:

1. Add entry to `peggy/users.nix`
2. Rebuild peggy (`sudo nixos-rebuild switch --flake github:Samasaur1/polytopia`)
3.
    ```bash
    sudo -i
    su ${NEW_USERNAME}
    cd
    mkdir .ssh
    curl -fsSL https://github.com/${GH_USERNAME}.keys > .ssh/authorized_keys
    exit
    passwd ${NEW_USERNAME}
    ```

### Upgrades

The NixOS machine(s) auto-upgrade(s), so the only thing necessary is to merge the weekly automated PR that updates the flake inputs.

The macOS machine(s) do(es) not auto-upgrade. To upgrade them, log in and run
```bash
darwin-rebuild switch --flake github:Samasaur1/polytopia#imacs
```
