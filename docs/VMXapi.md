# VMX API

VMX runs as a server and processes requests over HTTP.

---

By default, VMX runs on port 3000.  If running locally, the address of
VMX will be `http://localhost:3000` and if running remotely, the
address will be something like `http://192.168.1.134:3000` where the
IP address points to your server. If you're running on a vision.ai
hosted machine which uses https, the address will be something like
`https://demo.vision.ai/`, without the port.

## VMX REST API

The VMX REST API allows you to send commands to VMX to create new
detection processes, perform object detection, create new models, as
well as return the images inside a model's training set. The input and
outputs are always in JSON format (unless specified otherwise).

VERB    | Route   | Description
----|-------------| ----------
GET  | /session  | List open sessions
GET  | /model   |  List available models
POST | /session |  Create a new session
POST | /session/#session_id   |  Detect objects inside the image
GET  | /session/#session_id/params  | List loaded model's parameters
POST | /session/#session_id/edit   |  Show the model
PUT  | /session/#session_id/edit   |  Edit the model
POST | /session/#session_id/load   |  Load a new model
GET  | /check  | Check VMX version and whether this copy is licensed
POST | /activate/#key | Active this copy of VMX
GET  | /random | Return a random image from the models
GET  | /session/#session_id/log.txt | Last line of the log
GET  | /models/#ModelId/image.jpg | Visualize model
GET  | /models/#ModelId/model.data | Extract model file
GET  | /models/#ModelId/data_set/first.jpg | Return first image in model
GET  | /models/#ModelId/data_set/image.jpg | Return next image in model
GET  | /models/#ModelId/data_set/random.jpg | Return random image in model

#### Using curl and jq

To use the VMX REST API from the command line, we will be using `curl`
to send/receive requests and `jq` to render the resulting JSONs with
color. Your system should already have curl installed, and jq can be
downloaded from
[http://stedolan.github.io/jq/](http://stedolan.github.io/jq/).

## Example 1: Check the number of models and sessions

In this example, we will use the command line to check the number of
models as well as the number of open sessions.  We will then create a
new session with the model called "eyes", detect these objects
in a single image, and then shut down the session.

**Command line input**
```
curl http://localhost:3000/model | jq .
```

**Output**
```
{
  "data": [
    {
      "image": "models/008db1b3-acd3-49fe-94ea-a51297926ada/image.jpg",
      "history": [],
      "num_pos": 1000,
      "num_neg": 462,
      "size": [
        10,
        8
      ],
      "uuid": "008db1b3-acd3-49fe-94ea-a51297926ada",
      "name": "hoc_faces",
      "start_time": "2015-04-14T06:04:23.684Z",
      "end_time": "2015-04-14T06:42:57.985Z",
      "meta": ""
    },
    {
      "image": "models/05883a2b-c2f8-4cc9-bdc3-a17dd38e7c6f/image.jpg",
      "history": [],
      "num_pos": 100,
      "num_neg": 200,
      "size": [
        10,
        8
      ],
      "uuid": "05883a2b-c2f8-4cc9-bdc3-a17dd38e7c6f",
      "name": "joker",
      "start_time": "2015-03-27T02:00:51.784Z",
      "end_time": "2015-04-13T08:29:21.932Z",
      "meta": ""
    }
  ...
```

This output can become quite long. To quickly count the number of
available models from the command line, you can simply use the jq JSON
command line processor as follows:

**Command line input**
```
curl -s http://localhost:3000/model | jq '.data | length'
```

**Output**
```
64
```

Let's now check the number of running VMX sessions:

**Command line input**
```
curl -s http://localhost:3000/session | jq '.data | length'
```

**Output**
```
0
```

We have 64 models, but no loaded sessions, so let's create a new
session by POSTing to /session.

## Example 2: Load "eyes" model and get detections

Let's first find the UUID of the
model corresponding to the name "eyes". You can manually inspect
the returned JSON, or use jq to find the data element with the
matching name.

**Command line input**
```
curl -s http://localhost:3000/model | jq -r '.data[] | select(.name=="eyes") .uuid'
```

**Output**
```
e018112b-c9ba-437f-959d-49280acb8c9c
```

UUIDs are unique and assigned to object models at creation time, so
your personal model library will have different UUIDs.  ***Note:*** If
you are showing 0 models, then you'll need to create some using the
VMX GUI.

Let's create a new VMX session with this model UUID.

**Command line input**
```
curl -X POST -d '{"uuids":["e018112b-c9ba-437f-959d-49280acb8c9c"]}' http://localhost:3000/session
```

The output will give us a new session id.

**Output**
```

{ "data": {
    "id": "15c3a5dc-cffb-43ac-a5dd-6755f5376c81"
  }
}
```

We can now verify that the number of sessions is 1.

**Command line input**
```
curl -s localhost:3000/session | jq .
```

**Output**
```
{
  "data": [
    {
      "model": {
        "image": "models/1ad3282b-3fce-4f56-ae90-2a4d16d2f40d/image.jpg",
        "num_pos": 200,
        "num_neg": 200,
        "size": [
          10,
          10
        ],
        "uuid": "1ad3282b-3fce-4f56-ae90-2a4d16d2f40d",
        "name": "open_mouth",
        "start_time": "2015-04-15T02:58:01.115Z",
        "end_time": "2015-04-15T06:55:53.230Z"
      },
      "id": "24f362c8-75aa-43ca-8fc3-f9ceeaf5cef0"
    }
  ]
}
```

Let's now send an image URL to this VMX session and get the results of
the "eyes" detection. We will be using the following image:

[http://people.csail.mit.edu/tomasz/img/tomasz_blue_crop.jpg](http://people.csail.mit.edu/tomasz/img/tomasz_blue_crop.jpg)

<img src="http://people.csail.mit.edu/tomasz/img/tomasz_blue_crop.jpg"></img>

**Command line input**
``` 
curl -s -X POST -d '{"images":[{"image":"http://people.csail.mit.edu/tomasz/img/tomasz_blue_crop.jpg"}]}' localhost:3000/session/15c3a5dc-cffb-43ac-a5dd-6755f5376c81
```

**Output**
```
{
  "error": 0,
  "message": "Process Image Success",
  "time": 0.194657229,
  "model": {
    "uuid": "e018112b-c9ba-437f-959d-49280acb8c9c",
    "name": "eyes",
    "size": [
      4,
      10
    ],
    "num_pos": 882,
    "num_neg": 360,
    "start_time": "2015-03-16T04:29:36.921Z",
    "end_time": "2015-04-15T07:36:46.837Z",
    "image": "models/e018112b-c9ba-437f-959d-49280acb8c9c/image.jpg"
  },
  "objects": [
    {
      "name": "eyes",
      "bb": [
        103.7099005310307,
        172.78516300280293,
        274.2637297891478,
        242.85019767944317
      ],
      "score": 8.147063606844702
    }
  ]
}
```

In this example, we created a new VMX session with the "eyes"
detector, sent it the location of an image, and obtained the resulting
JSON which shows the location of the object as well as the resulting
confidence score.


---

## VMXserver API

VMX typically launches separate "VMXserver" processes to manage
multiple sessions, but you can start a standalone VMXserver process on
your own.

The VMXServer application interface is the way your application or
script talks to our system.  Even though the VMXserver application
interface is a full-fledged API, it is not a REST-API and lacks
multi-session support.  Things are likely to change in upcoming
releases, so it is better to write applications on top of the REST API
and not on top of the application interface.

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

#### Listing models

The command `list_models` will return a listing of UUIDs inside the
current VMX directory.

```sh
curl -X POST -d '{"command:"save_model","model_name":"new_model"}'
```

#### Loading a model

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

#### Creating a Model
To create a new model, we simply send a sequence of images with
bounding boxes, and the name of the new model name (`cls` in this case).

```json
{ "command" : "create_model" , "selections" :
[{"image" : "image1.jpg" , "bb" : [10,10,10,100] , "time" :
"2014-09-09T3:43.003Z", "cls" : "new_object"}]}
```

#### Saving a model
When no model_name is specified, it will use the current name assigned
to the model.  A new model_name can be provided, which will the save
the model with this new name and return a new model with the name updated.

```sh
curl -X POST -d '{"command:"save_model","model_name":"new_model"}'
```

#### Processing an image (detecting objects)

To perform object detection, you simply call process_image. Process
Image will return a set of bounding boxes associated with the image.
You can set images as either dataURLS, absolute file locations on
disk, or remote URLs.  This should give you enough flexibility to run
VMX in many different interesting scenarios.

The input to `process_image` also takes a params object.

```sh
{"command":"process_image","images":[{"image":"/VMXdata/first.jpg"}]}
```

#### Showing a model

Showing a model consists of extracting images for the postive and
negative examples used in the underlying machine learning model.

```sh
curl -X POST -d '{"command:"show_model",...}' localhost:8081
```

#### Editing a model

Editing a model consists of re-assigning negatives to the positive
class, removing negatives, re-assigning positives to the negative
class, or removing negatives.  After these swaps, learning is
performed for a few iterations, and this process can be repeated
indefinitely.

```sh
curl -X POST -d '{"command:"edit_model",...}' localhost:8081
```

#### Getting detection params

You can query the current detection params.

```sh
curl -X POST -d '{"command:"get_params"}' localhost:8081
```

#### Getting the config object

The config object is used for controlling debug parameters of
VMXserver (the contents of `config.json`) programmatically.  You can
get the config object as follows:

```sh
curl -X POST -d '{"command:"get_config"}' localhost:8081
```

#### Setting the config object
```sh
curl -X POST -d '{"command:"set_config","log_images":"true"}' localhost:8081
```

#### Shutting down VMX server

There is a simple command which lets you shut down a VMX session and
free up memory on your machine.

```sh
curl -X POST -d '{"command:"exit"}' localhost:8081
```

---


## VMX Directory Structure

#### Models

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

#### Sessions

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

---

Here is a typical directory structure on a deployed system:

* /vmx/models
* /vmx/models/#model_uuid
* /vmx/models/#model_uuid/model.json
* /vmx/models/#model_uuid/model.data
* /vmx/models/#model_uuid/image.jpg
* /vmx/models/#model_uuid/data_set.json
* /vmx/models/#model_uuid/data_set
* /vmx/models/#model_uuid/data_set/000001.jpg
* /vmx/models/#model_uuid/data_set/000001.json
* /vmx/sessions
* /vmx/sessions/#session_id/
* /vmx/sessions/#session_id/model.json
* /vmx/sessions/#session_id/log.txt


