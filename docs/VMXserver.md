# VMX Server: Object Detection Engine and API

This readme will first focus on installation/activation, then describe
the available VMX server API commands, and conclude with an overview
how VMX models are organized on your hard drive.

## Configuring VMX server

The VMX configuration file `config.json` lives right next to the
VMXserver binary and contains settings which can be set before VMX
starts.

```javascript
{
  "user"          : "",
  "license"       : "",
  "MCR"           : "/Applications/MATLAB/MATLAB_Compiler_Runtime/v83/",
  "models"        : "/vmx/models/",
  "sessions"      : "/vmx/sessions/",
  "data"          : "/vmx/data",
  "pretrained"    : "99ff9ba5c9c05078d54d9fbd49872a2c",
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


## Running VMX server

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
model called "none" which isn't goint to exist (so nothing gets loaded
initially), and it will run over port :8081.  All interaction with the
VMXserver is done by sending HTTP requests to localhost:8081. To start
the interaction, you should either manually or programatically send
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

## The VMX Engine API

The VMXServer application interface is the way your application or
script talks to our algorithms.  Even though is is a full-fledged API,
it is not a REST-API and lacks multi-session support.  Things are
likely to change in upcoming releases, so it is better to write
applications on top of the REST API and not on top of the application
interface.

The VMXserver application interface describes how to interact with a
single VMX object detection `process`.  The API currently consists of
the following 11 functions:


Command      | Description
-------------| ----------
list_models  |  List currently available models
load_model   |  Load a model
create_model |  Create a model from bounding boxes
save_model   |  Saves a model
process_image | Performs detection or learning on a new image
show_model   |  Show the model's positives and negatives
edit_model   |  Edit the model's positives and negatives and perform learning
get_params   |  Retrieve the process's detection parameters
get_config   |  Get the configuration object
set_config   |  Set the configuration object
exit         |  Stop the VMX server and clean up sessions

You issue these commands by writing a command json into the VMXserver
port.  The format of the command json is as
follows:

```sh
curl -X POST -d '{"command":"load_model","uuids":["UUID1"],"compiled",false}' localhost:8081
```
Where ... corresponds to additional arguments that are required to
make sense of the command.  Here is a short description of each of
these functions.

### Listing models

The command `list_models` will return a listing of UUIDs which are
inside the current VMX directory.

```sh
curl -X POST -d '{"command:"save_model","model_name":"new_model"}'
```

### Loading a model

To load a model or a set of models, you need a list of UUIDs. In the
context of loading models, a UUID can be either a uuid string, the
absolute file location to a model.data file on local disk, or a remote
URL (must start with http).

A model can be loaded in the `compiled:true` state, which has a reduced
memory footprint and performs detection a little bit faster than the
uncompiled one.  However, a `compiled` model cannot go into learning
mode, so beware.  To enable, set the `compiled` field to true.

```sh
curl -X POST -d '{"command":"load_model","uuids":["UUID1"],"compiled":false}' localhost:8081
curl -X POST -d '{"command":"load_model","uuids":["UUID1","UUID2"],"compiled":true}' localhost:8081
curl -X POST -d '{"command":"load_model","uuids":["/incoming/model.data"],"compiled":false}' localhost:8081
curl -X POST -d '{"command":"load_model","uuids":["http://vision.ai/uuid1/model.data"],"compiled":false}' localhost:8081
```

### Creating a Model
To create a new model, we simply send a sequence of images with
bounding boxes, and the name of the new model name (`cls` in this case).

```json
{ "command" : "create_model" , "selections" :
[{"image" : "image1.jpg" , "bb" : [10,10,10,100] , "time" :
"2014-09-09T3:43.003Z", "cls" : "new_object"}]}
```

### Saving a model
When no model_name is specified, it will use the current name assigned
to the model.  A new model_name can be provided, which will the save
the model with this new name and return a new model with the name updated.

```sh
curl -X POST -d '{"command:"save_model","model_name":"new_model"}'
```

### Processing an image (detecting objects)

To perform object detection, you simply call process_image. Process
Image will return a set of bounding boxes associated with the image.
You can set images as either dataURLS, absolute file locations on
disk, or remote URLs.  This should give you enough flexibility to run
VMX in many different interesting scenarios.

The input to `process_image` also takes a params object.

```sh
{"command":"process_image":"image":"/VMXdata/first.jpg"}
{"command":"process_image":"image":"/VMXdata/first.jpg","fast":1,"scale":1}
```

### Showing a model

Showing a model consists of extracting images for the postive and
negative examples used in the underlying machine learning model.

```sh
curl -X POST -d '{"command:"show_model",...}' localhost:8081
```

### Editing a model

Editing a model consists of re-assigning negatives to the positive
class, removing negatives, re-assigning positives to the negative
class, or removing negatives.  After these swaps, learning is
performed for a few iterations, and this process can be repeated
indefinitely.

```sh
curl -X POST -d '{"command:"edit_model",...}' localhost:8081
```

### Getting detection params

You can query the current detection params.

```sh
curl -X POST -d '{"command:"get_params"}' localhost:8081
```

### Getting the config object

The config object is used for controlling debug parameters of
VMXserver (the contents of `config.json`) programatically.  You can
get the config object as follows:

```sh
curl -X POST -d '{"command:"get_config"}' localhost:8081
```

### Setting the config object
```sh
curl -X POST -d '{"command:"set_config","log_images":"true"}' localhost:8081
```

### Shutting down VMX server

There is a simple command which lets you shut down a VMX session and
free up memory on your machine.

```sh
curl -X POST -d '{"command:"exit"}' localhost:8081
```

## VMX Directory: Models

In order to recognize something in an image, you need to first learn a
model.  A model is a collection of positive and negative examples used
to describe a visual concept.  Models can be used to detect objects in
images and videos, and one of VMX's key strength is the ability to let
you easily make your own models.  You can use pre-trained models,
interactively re-train existing models, or just train your own by
waving an object in front of your webcam.  VMX can go into "automatic
learning mode", so you can observe the algorithm get better as it is
detecting objects in real-time.  Each model has a human-readable name
(e.g., "dog" or "tom") as well as its own unique birth certificate (we
use a 32 alphanumeric character universally unique identifier, or
UUID, to identify models). Models are stored in a
vmx_dir/models/model_id folder on your hard drive.  Each model also
contains customizable parameters (e.g., "max_image_size",
"detector_quality") which can be modified in real-time to adjust the
speed and performance of the running detector.

Inside each model directory, there is a `model.json` file which
contains meta-data about the model such as its human-readable `name`
(e.g., 'face', 'Tom', or 'left_hand'), a `data_set.json` file which
contains the data set of images and object locations used to train the
model, a `image.jpg` image of the model, a `params.json` file
containing the customizable parameters associated with the model, and
a binary file `model.data` with the internal representation of the
model as used by VMX.

*NOTE*: As you train more and more models, you should backup your models
directory so that you do not lose any of your work.

## VMX Directory: Sessions

Many applications require multiple object detectors, so we've made it
easy to run multiple VMX processes.  Each VMX process can have
different models loaded in memory and can separately go into learning
mode.  A session directory is created for each running VMXserver
process.  Sessions are referred to by UUIDs, and local session
information is stored in a sessions/session_id folder on local disk.
Local session information consists of a file
`sessions/session_id/model.json` which stores the information about
the models loaded into the session `session_id`.  The session
directory is also where information gets logged, so a
`sessions/session_id/log.txt` file will contain API logs of the VMX
process.

*NOTE*: The more you use VMX, your /sessions/ folder will grow with
longs of old sessions. You should either backup your logs (if you are
debugging your application) or feel free to delete the entire sessions
directory once you've made sure no VMX processes are active.

*NOTE*: The best way to launch main VMX processes is via the REST API
 provided in the VMX package.

## VMX Directory: Sessions
Here is a typical directory structure on a deployed system:

* /vmx/models
* /vmx/models/model_uuid
* /vmx/models/model_uuid/model.json
* /vmx/models/model_uuid/model.data
* /vmx/models/model_uuid/image.jpg
* /vmx/models/model_uuid/data_set.json
* /vmx/models/model_uuid/data_set
* /vmx/models/model_uuid/data_set/000001.jpg
* /vmx/models/model_uuid/data_set/000001.json

* /vmx/sessions
* /vmx/sessions/session_id/
* /vmx/sessions/session_id/model.json
* /vmx/sessions/session_id/log.txt


***Copyright 2013-2014 vision.ai, LLC. All rights reserved.***
