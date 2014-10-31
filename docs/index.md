# Welcome to VMX Docs


The VMX Object Detection Engine comes with a highly-optimized visual
object detection algorithm engineered for speed, accuracy, and
ease-of-use.  VMX lets you quickly train new object models as well use
those models as object detectors for recognizing/localizing/tracking
objects in images and videos. The VMX Engine runs as a server and uses
a simple JSON-based command API so you can build apps in your favorite
programming language as well as interact with VMX over the HTTP
protocol.  For those of you that like cats, awks, and pipes, VMX can
also take commands from standard input (*command line support is
built-in*).  VMX is developed and maintained by vision. ai, LLC.

VMX runs on your personal computer, with native installers for Mac OS
X and Linux, as well as a Docker support which supports Windows, Mac
OS X, and Linux.  The VMX package consists of VMX Server, VMX Middle,
and the VMX App Builder.

This readme will first focus on installation/activation, then describe
the available VMX server API commands, and conclude with an overview
how VMX models are organized on your hard drive.

## Installing VMX

To install VMX, you need to download an installer, or use a docker image. VMX requires v8.3 of the Matlab Compiler Runtime
(R2014a).  The latest VMX releases and the required MCR can be found below.


|OS | Installer | MATLAB MCR|
|---|---------- | ----------|
|Mac OS X | <img src="img/osx.png" alt="Drawing" style="width: 100px;"/><br/><a href="http://files.vision.ai/vmx/Mac/VMX.pkg">VMX.pkg</a> | <img src="img/matlab.png" style="width:100px;"> <br/><a href="http://www.mathworks.com/supportfiles/downloads/R2014a/deployment_files/R2014a/installers/maci64/MCR_R2014a_maci64_installer.zip">MCR_mac.zip</a>|
| | | |
| | | |
| | | |
| | | |
|Linux | Native Docker supported | included in docker |
|Windows | boot2docker supported | included in docker |

##

If you need to download any of the individual VMX components, download
an older version, or want to try a bleeding-edge experimental build,
please visit [https://files.vision.ai/](http://files.vision.ai/).

###Mac OS X
The Mac OS X VMX bundle together with the MATLAB MCR contain all
required libraries you will need for your Mac.  

###Linux

On linux we support a Docker installation.  With Docker installed, you simply need to download our <a href="https://github.com/VISIONAI/vmx-docker-manager">docker manager</a>.

For example, to start vmx on port 3000:

```
git clone git@github.com:VISIONAI/vmx-docker-manager.git

cd vmx-docker-manager

./vmx start 3000
```

When you run `./vmx init` (or `./vmx start PORT` for the first time),
a docker container with the binaries is started, which creates a
volume at `/vmx/build`

For information on installing docker please see the
[Docker Documentation](https://docs.docker.com/installation/#installation)

If you choose to use install VMX on a Linux machine without using
Docker, please refer to our Dockerfile to see the required packages
and libraries.


### Defaults MCR Location

VMX server will look for the MCR inside the following default
locations:

OS | Default MCR location
------- | ---------
Linux    | Brought in as a volume from visionai/vmxmcr to `/root/MATLAB/`
Mac OS X | `/Applications/MATLAB/MATLAB_Compiler_Runtime/`

The MCR field of the VMX `config.json` configuration file (See
[Configuring VMX](#configuration)) points to the MCR directory and can
be set to anything you like if you choose to install the MCR in an
unorthodox location.

### Mac OS X notes

For MacOSX, VMX is typically installed into either
`/Applications/VMX.app/` or `~/Applications/VMX.app/`. The location of
the `VMX binary ` will be `/Applications/VMX.app/Contents/MacOS/` and
the location of the `VMX server binary` will be
`/Applications/VMX.app/Contents/MacOS/VMXserer.app/Contents/MacOS/`.

To uninstall in Mac OS X, simply remove the /Applications/VMX.app
folder into your Trash.  VMX stores all of its files within this
directory, so be sure to back up your models if you're created any of
your own.

The MAC OS X installer will use `/tmp/mcr_cache` as the MCR cache
directory.  If you're having issues with installation/activation, make
sure you have read/write permissions for this folder.  You can also
try removing the directory `/tmp/mcr_cache` in the case it gets corrupted.
VMXserver will regenerate a cache directory if it is not present.

To uninstall in Mac OS X, simply remove the /Applications/VMX.app
folder into your Trash.  VMX stores all of its files within this
directory, so be sure to back up your models if you have created any
of your own.





## Activating VMX

To run VMX locally, each VMX installation requires a valid key, an
agreement of the End User Licensing Agreement, and an internet
connection to convert a key into a valid license from the vision.ai
activation server.  Activation is usually performed from within the
VMX App Builder program, but you can visit
[https://forums.vision.ai](https://forums.vision.ai) for more help if
you need to activate VMX a different way.

A valid key corresponding to an personal license can be purchased from
[https://vision.ai](https://vision.ai).  Please see
[https://forums.vision.ai](https://forums.vision.ai) to learn more about any specials offers and
finding out how to be a beta tester.


### Command line activation
Once you've obtained a valid VMX key, you can perform the activation
procedure on the command line:

```sh
cd /Applications/VMX.app/Contents/MacOS/VMXserver.app/Contents/MacOS/
./activate.sh key email
```

### Checking the activation

To check the activation, you can either run:

```sh
cd /Applications/VMX.app/Contents/MacOS/VMXserver.app/Contents/MacOS/
./VMXserver -check
```

Or you can visit
[http://localhost:3000/check](http://localhost:3000/check) in your browser.

This documentation can be found at
[docs.vision.ai](http://docs.vision.ai).

***Copyright 2013-2014 vision.ai, LLC. All rights reserved.***
