# VMX Vision App Builder


The VMX Vision App Builder is one of the most powerful apps running on
top of the VMX API.  Inside the App Builder you can create models and
interact with them in real time.

## External Source

To set the external source to be other than the webcam, simply load
the VMX App Builder and hit **Deny** when VMX asks to use your webcam.

When choosing an external source, you have several options:

#### Load from a custom URL

A custom URL allows you to use just about any IPcam.  Any URL which
returns an image can be used as an image stream.

#### Load from /random

This will randomly cycle through all model images inside VMX.

#### Load from models/#model_uuid/stream

You can also randomly cycle through all model images inside a specific
model folder.

## Loading Models

To load a model, just click the "Load Model" button.  A new session
will be created with the model you just selected.

## Customizing Models

To customize a model, you can change its internal parameters.  With
these knobs, you can adjust speed and performance -- we provide many
different parameters which you are free to play with.  First load a
model, and then click on the "parameters" button.

## Creating Models

To create a model, click on on the "eye" icon.

## Learning Mode

To improve a model, it can automatically go into "learning mode."
While in Learning Mode, the model will grow over time but it will
become better.

## Editing Models

Click on the "Edit Model" button to see a visualization of the
positives and negatives inside the model.  You are free to move the
positives to the negative side, and vice-versa.  In very difficult
training scenarios, you will have to use this Model Editor to clean up
any mistakes made by the automatic learning algorithm.

***Copyright 2013-2014 vision.ai, LLC. All rights reserved.***
