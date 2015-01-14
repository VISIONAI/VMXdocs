# VMX Installation

Welcome to the VMX Documentation pages.  VMX is a web-based object
recognition server made by vision.ai, LLC.

---

## Downloading VMX

You can download a VMX installer for Mac OS X, or use Docker
when using Linux. VMX requires v8.3 of the Matlab Compiler Runtime
(MCR) R2014a -- a separate 1.6GB download from the Mathworks, Inc
website.  When using Docker, all dependencies including the MATLAB MCR
will be automatically downloaded.

| | | |
|---|:----------:|:----------:|
|  | VMX Installer | MATLAB MCR|
|Mac OS X | <a href="https://files.vision.ai/releases/VMX.pkg"><img src="img/v_square.png" alt="VMX.pkg" style="width: 100px;"/></a><br/><a href="https://files.vision.ai/releases/VMX.pkg">VMX.pkg</a> | <a href="http://www.mathworks.com/supportfiles/downloads/R2014a/deployment_files/R2014a/installers/maci64/MCR_R2014a_maci64_installer.zip"><img src="img/matlab.png" alt="MCR" style="width:100px;"/></a> <br/><a href="http://www.mathworks.com/supportfiles/downloads/R2014a/deployment_files/R2014a/installers/maci64/MCR_R2014a_maci64_installer.zip">MCR_mac.zip</a>|
| | | |
| | | |
| | | |
| | | |
|Linux | <a href="https://github.com/VISIONAI/vmx-docker-manager">vmx-docker-manager</a> | included in docker |
|Windows| boot2docker + <a href="https://github.com/VISIONAI/vmx-docker-manager">vmx-docker-manager</a> | included in docker |

##

If you need to download any of the individual VMX components, download
an older version, want to try a bleeding-edge experimental build, or
want to match your download against our MD5 checksums, please visit
[https://files.vision.ai/vmx](https://files.vision.ai/vmx).

### Linux

On Linux, we support a Docker installation.  After Docker is
installed, download vision.ai's <a
href="https://github.com/VISIONAI/vmx-docker-manager">docker
manager</a>.

For example, to start VMX on port 3000:

```
git clone https://github.com/VISIONAI/vmx-docker-manager.git

cd vmx-docker-manager

./vmx start 3000
```

When you run `./vmx init` (or `./vmx start PORT` for the first time),
a docker container with the binaries is started, which creates a
volume at `/vmx/build`

For information on installing docker please see the
[Docker Documentation](https://docs.docker.com/installation/#installation)

If you choose to install VMX on a Linux machine without Docker, please
refer to our Dockerfiles to see the required packages and libraries.

### boot2docker

[boot2docker](http://boot2docker.io/) is a lightweight Linux
distribution made specifically to run Docker containers.  It runs
completely from RAM, weight ~27MB and boots in ~5s(YMMV).  This allows
you to run VMX on a Windows computer, as well as provide an
alternative method for installing on a Mac OS X system.

### Default MCR Location

VMX server will look for the MCR inside the following default
locations:

  | 
------- | ---------
Linux    | A volume from visionai/vmxmcr to `/root/MATLAB/`
Mac OS X | `/Applications/MATLAB/MATLAB_Compiler_Runtime/`

##

The MCR field of the VMX `config.json` configuration file (See
[Configuring VMX](VMXinstall.md) points to the MCR directory and can
be set to anything you like if you choose to install the MCR in a
different location.

### Mac OS X notes

On MacOSX, VMX installs into `/Applications/VMX.app/` or
`~/Applications/VMX.app/`. The location of the `VMX binary ` will be
`/Applications/VMX.app/Contents/MacOS/` and the location of the `VMX
server binary` will be
`/Applications/VMX.app/Contents/MacOS/VMXserer.app/Contents/MacOS/`.

To uninstall in Mac OS X, move the `/Applications/VMX.app` folder into
your Trash.  VMX stores models inside this directory, so be sure to
back up your models before uninstalling.

The Mac OS X installer will use `/tmp/mcr_cache` as the MCR cache
directory.  If you're having issues with installation/activation, make
sure you have read/write permissions for this folder.  You can also
try removing the directory `/tmp/mcr_cache` in the case it gets corrupted.
VMXserver will regenerate a cache directory if it is not present.

To uninstall in Mac OS X, simply remove the /Applications/VMX.app
folder into your Trash.  VMX stores all of its files within this
directory, so be sure to back up your models if you have created any
of your own.

---


## Activating VMX

To run VMX locally, each VMX installation requires a valid key and an
internet connection to obtain a valid license from the vision.ai
activation server.  Activation is per-machine, and a new key/license
is required for installation on a new machine.  Activation is usually
performed from within the VMX App Builder program, but can also be
done from the command line.  Simply start the VMX application and the
GUI will help you activate the software.  You can visit the
[vision.ai forums](https://forums.vision.ai) if you are having issues
with activation.

A valid VMX beta key corresponding to a personal license can be
purchased from [https://beta.vision.ai](https://beta.vision.ai).
Please see [vision.ai forums](https://forums.vision.ai) to learn how
to be a beta tester.

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
[http://localhost:3000/check](http://localhost:3000/check) in your
browser.

---


## Updating VMX

Your VMX license will work with all 0.x.x releases, leading up to
the 1.0 release. To check for more recent VMX versions, see
[https://files.vision.ai/vmx/](https://files.vision.ai/vmx).  On Mac
OS X, you can download the most recent installer: it will overwrite
the old binaries, automatically transfer over your existing license,
and leave your models intact. To be safe, it is a good idea to backup
your `config.json` file which contains the key and license information
to run future versions of VMX on **your** computer.  When running the
VMX installer a second time, the installer will save your old config
files to `/tmp/vmx_installer.config.json` and
`/tmp/vmx_installer.settings.yml`.




The VMX server performs the object recognition computations required
to deliver a robust and real-time object detection experience.  This
page explains the available VMX server API commands, and describe how
VMX models are organized on your hard drive.

---

## Configuring VMX server

The VMX configuration file `config.json` is located in the same
directory as the VMXserver binary and contains settings which can be
set before VMX starts.

```javascript
{
  "user"          : "",
  "license"       : "",
  "MCR"           : "/Applications/MATLAB/MATLAB_Compiler_Runtime/v83/",
  "models"        : "/vmx/models/",
  "sessions"      : "/vmx/sessions/",
  "data"          : "/vmx/data",
  "pretrained"    : "3f61ce5c7642bc2f24f7286f600b3e6b",
  "log_images"    : false,
  "log_memory"    : false,
  "display_images": false
}
```


If enabled, *display_images* will display image detections on your
desktop.  This is useful for debugging purposes.  If enabled,
*log_memory* will log memory usage of VMX.  If enabled, *log_images*
will dump full dataURLs into the log, which makes them quite big, but
allows somebody from vision.ai to diagnose any issues you might be
having.  The *user* and *license* fields get automatically set during
the activation procedure.

---


## VMX server via command-line

Once you've extracted the binaries into a directory such as
`/Applications/VMXserver.app/Contents/MacOS/`, you can test the
installation by running VMX from command line: `./VMXserver`

Running VMXserver without any inputs will print out a typical Usage
string. VMX requires a vmx_dir directory string as well as a
session_id identifier.  An optional model_uuid (for loading a model at
start) and port number can be specified.  The standard way to start
VMX is to give it a port number, such as ":8081", but if a port of
":0" is specified, VMX will assign a port on its own, and will echo
the port to screen as well as write a file called
`vmx_dir/sessions_id/url` which will contain the URL for the running
VMX server.

```sh
./VMXserver vmx_dir session_id [model_id] [port]
```

Here is an example (note that the port starts with a colon)

```sh
./VMXserver /www/vmx/ f7 none :8081
```

This will launch a new VMXserver process with the /www/vmx/ base
directory and "f7" as the name of the session.  It will try to load a
model called "none" which isn't going to exist (so nothing gets loaded
initially), and it will run over port :8081.  All interaction with the
VMXserver is done by sending HTTP requests to localhost:8081. To start
the interaction, you should either manually or programmatically send
the HTTP request to localhost:8081 with a properly formatted JSON
object.  All VMX inputs and outputs are in JSON format, and VMX server
will return an error if it cannot parse the input correctly or of in
internal error occurred.  Here is an example of a command being sent
to VMX server running on port 8081.

```sh
curl -X POST -d '{"command":"list_models"}' http://localhost:8081
```

You can alternatively start VMXserver in "stdin" mode where input
commands can by input directly on the command line.

```sh
./VMXserver /vmx_dir/ stdin none
```

While typing in long commands by hand is not useful, you can then pipe
commands into VMX server:

```sh
cat commands.file | ./VMXserver /vmx_dir/ stdin none
```

Because all of VMX standard output is written in JSON, you can pipe
the output of VMX into jq (the command-line JSON processor).

```sh
cat commands.file | ./VMXserver /vmx_dir/ stdin none | jq .
```

