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
    ans = input(f"Overwrite {path}? [y/n]: ").strip().lower()
    return ans in ("y", "yes")


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


def collect(config):
    for name, spec in config.items():
        src = expand(spec["src"])
        dest = os.path.join(os.path.dirname(__file__), "dotfiles", spec["dest"])

        print(f"[Collect] {name}: {src}")
        if not os.path.exists(src):
            print(f"[Warning] source not found: {name}: {src}")
            continue

        overwrite(src, dest)


def install(config):
    for name, spec in config.items():
        src = os.path.join(os.path.dirname(__file__), "dotfiles", spec["dest"])
        dest = expand(spec["src"])

        print(f"[Install] {name}: {dest}")
        if not os.path.exists(src):
            print(f"[Warning] source not found: {name}: {src}")
            continue

        if os.path.exists(dest):
            if not ask_overwrite(dest):
                print(f"[Skip] {name}: {dest}")
                continue
            overwrite(src, dest)


def usage():
    print("Usage: python manager.py [collect|install]")


def main():
    if len(sys.argv) != 2:
        usage()
        sys.exit(1)

    config_path = "./targets.toml"
    config = load_config(config_path)

    cmd = sys.argv[1].lower()
    if cmd == "collect":
        collect(config)
    elif cmd == "install":
        install(config)
    else:
        usage()
        sys.exit(1)


if __name__ == "__main__":
    main()
