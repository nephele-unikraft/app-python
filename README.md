# python3 application for Unikraft
This is a python3 application for Unikraft.

## Step 1: Clone the repositories
Run `./scripts/unikraft-clone.sh <newdir>` to create a distribution
(read: will clone all needed repositories) in `<newdir>` with all the
libraries required for building this application. After that change directory
to the application directory:

```bash
cd <newdir>/apps/python
```

## Step 2: Build the application
Run `make` to build the application. This will do the following in order:
1. Copies the `config/config-unikraft-build` file as `.config` and use
it as the build configuration.

2. Downloads the original code of each library and apply the patches needed for
running with Unikraft.

3. Generates the application binaries in the `build/` subdirectory.

DO NOT run a parallel build (i.e. `make -j<N>`) the first time. You can use
it afterwards.

## Step 3: Build the Python runtime
We need the Python runtime to run the application successfully. For this we
need to run:

```bash
make python-rootfs path=<new rootfs directory>
```

It will create the root filesystem in the directory you choose and it will
install the Python runtime into it. The generated root filesystem may be used
either as a 9pfs filesystem or as a ramfs.

For generating the ramfs you need to run:

```bash
./scripts/create-ramfs.sh <new rootfs directory> <out ramfs file>
```
## Step 4: Run the application
You can start using the `config/xl.conf` and change it according to your
options. Please notice how you can fill the path of your Python script (check
`scripts/` directory for `myscript.py`):

```
cmdline = "vfs.rootdev=test -- /root/myscript.py"
```

After you update the configuration file you can run it with:

```bash
xl create config/xl.conf
```

You can check whether your VM started successfully with `xl list` command:

```bash
$ xl list
Name                                        ID   Mem VCPUs      State   Time(s)
Domain-0                                     0  3072     6     r-----   13243.7
unikraft-python                              8   512     1     -b----       0.2
```

You can connect to your VM console by using it domain ID:

```bash
xl console 8
```
