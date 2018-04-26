# docker-emacs-jp

Execution environment of Emacs created with docker for Japanese.

## Getting Started
### Prerequisites

What things you need to install the software.

* Connectivity to the INTERNET
* Docker on Linux

```
$ docker version
Client:
 Version:       17.12.0-ce
 API version:   1.35
 Go version:    go1.9.2
 Git commit:    c97c6d6
 Built: Wed Dec 27 20:10:14 2017
 OS/Arch:       linux/amd64

Server:
 Engine:
  Version:      17.12.0-ce
  API version:  1.35 (minimum version 1.12)
  Go version:   go1.9.2
  Git commit:   c97c6d6
  Built:        Wed Dec 27 20:12:46 2017
  OS/Arch:      linux/amd64
  Experimental: false
```

### Installing

1. Temporarily set `/proc/sys/kernel/randomize_va_space` to 0.
    * `$ sudo bash -c "echo 0 > /proc/sys/kernel/randomize_va_space"`
1. Run `docker_build.sh` and wait a while.
    * `$ ./docker_build.sh`
1. Successful if the log on the screen ends with the following.

```
    Successfully tagged kiyoad/emacs:latest
```

## Running

* Running `emacs.sh` starts Emacs.
    * At start-up, mount the current home directory in the container's home directory.
    * It is changing the detach key of the container. Please check `emacs.sh` for details.

## Built With

* Emacs
* Global
* Git
* Go
* Asciidoctor

## License

This project is licensed under the MIT License.
