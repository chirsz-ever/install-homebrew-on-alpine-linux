# Install Homebrew on Alpine Linux

There is a wiki page with the same title as this article in the original Linuxbrew repository
(now merged into Homebrew)[^1], but the information there is slightly out of date. So here is a
more up-to-date version.

[^1]: <https://github.com/Linuxbrew/brew/wiki/Alpine-Linux>

You can start Alpine Linux with the `alpine` Docker image:

```sh
docker run -it --rm alpine:latest sh
```

## Prepare dependencies

TODO: no curl

```sh
apk add bash curl git libc6-compat sudo
sed -i -- '1a\
case $1 in --version)\
    echo "ldd 2.16"\
    exit\
esac' /usr/bin/ldd
ln -s /bin/stat /usr/bin/stat
rm /bin/grep
wget -O /bin/grep https://raw.githubusercontent.com/chirsz-ever/install-homebrew-on-alpine-linux/master/patched-grep.sh
chmod +x /bin/grep
rm /usr/bin/sort
wget -O /usr/bin/sort https://raw.githubusercontent.com/chirsz-ever/install-homebrew-on-alpine-linux/master/patched-sort.sh
chmod +x /usr/bin/sort
```

Homebrew now can automatically download and install [Potable Ruby](https://github.com/Homebrew/homebrew-portable-ruby),
so we don't need to install Ruby from the package manager.

Potable Ruby depends on glibc, and Alpine Linux uses musl libc, so we need to install the `libc6-compat` package. On
newer versions of Alpine Linux, `libc6-compat` is an alias for `gcompat`.

The installation script would use `ldd` to check the glibc version, so we use `sed` to patch the `ldd` script.

The installation script uses `/usr/bin/stat`, but Alpine Linux only has `/bin/stat`, so we create a symlink.

The installation script uses `grep` and `sort` with options that are not supported by busybox, so we need to replace
them with patched versions. You can also just install `coreutils` package.

## Add a normal user

Add a normal user, add it to the `wheel` group, and allow it to use `sudo`. Homebrew do not allow running as root, so we
need a normal user.

```sh
adduser tom
adduser tom wheel
echo '%wheel ALL=(ALL:ALL) ALL' > /etc/sudoers.d/99-custom
su -l tom
```

## Dwonload the installation script and run it

```sh
wget https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
bash install.sh
```

## Post-installation

Try running some commands and install some packages.

```sh
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv sh)"
brew doctor
brew install hello
hello
```

NOTE:

- `brew shellenv` without arguments will failed, because it needs `ps` to support `-p` option, which is not supported
by busybox. You can use like `brew shellenv sh` to declare the shell type explicitly, or install `procps-ng` package.
- `brew list` will fail, because it needs `ls` to support `-q` option, which is not supported by busybox. You can
install `coreutils` package, or use [the patched ls script](./patched-ls.sh) to replace `/bin/ls`.
- the uninstallation script will fail, because it needs `find` to support `-lname` filter, which is not supported by
busybox. You can install `findutils` package to fix this.
