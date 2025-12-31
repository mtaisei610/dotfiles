import sys
import os
import shutil
import tomllib


def load_config(path: str):
    if not os.path.exists(path):
        print(f"[Error] config file not found: {path}")
        sys.exit(1)

    with open(path, "rb") as f:
        return tomllib.load(f)


def expand(path):
    return os.path.abspath(os.path.expanduser(path))


def ask_overwrite(path):
    while True:
        ans = (
            input(f"Overwrite or backup {path}? [(y)es/(s)kip/(b)ackup]: ")
            .strip()
            .lower()
        )
        if ans in ("b", "bak", "backup"):
            return "bak"
        elif ans in ("y", "yes"):
            return "yes"
        elif ans in ("s", "skip"):
            return "skip"
        else:
            print("Please answer y, s, or b.")
            continue


def overwrite(src, dest):
    if os.path.exists(dest):
        if os.path.isdir(dest):
            shutil.rmtree(dest)
        else:
            os.remove(dest)

    if os.path.exists(src):
        if os.path.isdir(src):
            shutil.copytree(src, dest)
        else:
            shutil.copy(src, dest)


def backup(dest):
    bak = dest + ".bak"
    if os.path.exists(bak):
        if os.path.isdir(bak):
            shutil.rmtree(bak)
        else:
            os.remove(bak)
    print(f"[Bakup] {dest} -> {bak}")

    if os.path.isdir(dest):
        shutil.copytree(dest, bak)
    else:
        shutil.copy2(dest, bak)


def collect(config):
    for name, spec in config.items():
        src = expand(spec["src"])
        dest = os.path.join(os.path.dirname(__file__), "dotfiles", spec["dest"])

        print(f"[Collect] {name}: {src}")
        if not os.path.exists(src):
            print(f"[Warning] source not found: {name}: {src}")
            continue

        overwrite(src, dest)


def install(config, targets):
    for name, spec in config.items():
        if targets is not None and name not in targets:
            continue

        src = os.path.join(os.path.dirname(__file__), "dotfiles", spec["dest"])
        dest = expand(spec["src"])

        print(f"[Install] {name}: {dest}")
        if not os.path.exists(src):
            print(f"[Warning] source not found: {name}: {src}")
            continue

        if os.path.exists(dest):
            choice = ask_overwrite(dest)
            match (choice):
                case "yes":
                    overwrite(src, dest)
                    continue
                case "skip":
                    print(f"[Skip] {name}: {dest}")
                    continue
                case "bak":
                    backup(dest)
                    overwrite(src, dest)
                    continue


def usage():
    print(
        "Usage: \n"
        "  python manager.py collect\n"
        "  python manager.py install [name ...]\n"
    )


def main():
    if len(sys.argv) < 2:
        usage()
        sys.exit(1)

    config_path = "./targets.toml"
    config = load_config(config_path)

    cmd = sys.argv[1].lower()
    if cmd == "collect":
        collect(config)
    elif cmd == "install":
        targets = sys.argv[2:] or None
        if targets:
            for t in targets:
                if t not in config:
                    print(f"[Warning] unknown target: {t}")
        install(config, targets)
    else:
        usage()
        sys.exit(1)


if __name__ == "__main__":
    main()
