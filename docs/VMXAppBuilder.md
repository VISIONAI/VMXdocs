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

## Model Parameters

To customize a model, you can change its internal parameters.  With
these knobs, you can adjust speed and performance -- we provide many
different parameters which you are free to play with.  First load a
model, and then click on the "parameters" button.

### Cell Size
Cell size is the feature analysis window size (in pixels).  Try
setting cell size to 4pixels for detecting small object instances.

### Left-Right Image Flip
Enabling this option will apply the detector on the original image as
well as the left-right flip.  The flip is done on the backend, so only
one image is sent to the server.  Enabling this option helps for
objects with horizontal symmetry (e.g., left-hand and right-hand).

### Maximum Overlap Threshold
This determines which "redundant" bounding boxes to keep after
applying the detector.  In the computer vision literature, this is
commonly known as non-maximum suppression.

A large overlap threshold (e.g., 0.8) will keep many redundant
detection boxes around the true positive and a very small overlap
threshold (e.g., 0.0), will never return overlapping detections.

### Detection Display Threshold
This number controls which detection windows to display.  This knob
defaults at -1.0, but a properly-trained model will show nicer detection
with a score of 0.0.  A smaller number will show more detections.

### # of Learning Iterations
The number of learning updates performed at each iteration of
learning.  A larger number will make learning slower, but more work
will be spent on learning between iterations.

### # of Learning Positives
During Learning Mode, this specified the maximum number of positives
to expect in an image.  The most common setting is 1, but setting this
to 0, will put the detector in negative learning mode, where every
image is treated as a negative.

### Learning Update Threshold
The threshold which determines if a candidate window should be
considered a positive.  The default of 0.0 is too high for certain
difficult objects, or objects not initialized with enoughd data.  If
you are having an issue getting Learning Mode to pick up new examples,
consider setting this threshold to -1, acquiring new examples, then
setting it back to 0.0.  Keeping this threshold at -1 for a long time
will likely make the detector absorb negatives into the positive set.


### Detector Quality

The quality of the detector determines the number of candidate windows
evaluated.  A detector quality of 1 will produce at most a single
detector, while a detector quality of 3000 will produce many
detection all over the input image.  If you want fast detection,
consider setting the detector quality to 1.0.  If you want to absorb
more negatives during learning, consider setting this to the maximum
value of 3000.


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
