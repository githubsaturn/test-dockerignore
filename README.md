See https://github.com/caprover/caprover/issues/2157

- Clone this repo
- Run `rm -rf .git` to ensure this repo's git is deleted
- Run `sudo ./build_image.sh`

You will see that the `.git` directory (inside the tarfile) was copied over despite of .dockerignore.
