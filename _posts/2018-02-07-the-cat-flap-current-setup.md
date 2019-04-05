---
layout: "post"
title: "the cat flap: current setup"
date: "2018-04-02"
categories: [raspberry-pi]
tags: [cat, raspberry-pi]
---

>"Hey, did you give the cat half a dead rabbit for dinner?"

Even in my own dream, this earns me a strange look.

_warning: More talk of my cat's hunting activities in this post._
{:.warning}

<!--more-->

As it turned out, my imaginary housemates weren't serving up bisected bunnies along with his usual _Whiskas_; the little bugger had taken it upon himself to supplement his meals with fresh meat by keeping a larder of live animals underneath the floorboards. Alas, my dream-self wasn't monitoring the dream-catflap with a dream-PiCamera. If I had been, I would have seen him sneaking them in...

![brazenly carrying a rabbit in through the catflap](/assets/images/hereiam.jpg)

this poor bunny actually survived the encounter
{:.caption}

## hardware
Aesthetically, it is not the most pleasing setup.

![the whole setup](/assets/images/setup-whole-labelled.jpg)

I have tried my best to make it look nice, but there's only so much I can do when one of the cat's favourite activities is ruining things I've made for him.

<video autoplay="" muted="" loop="">
        <source src="http://s3.eu-west-2.amazonaws.com/isthecatin-images/cat_1495606756_1777022-0.mp4" type="video/mp4">
        this is a video, and apparently your browser doesn't support that.
</video>

kindly demonstrating my point about destroying things
{:.caption}

The centrepiece of the setup is the [Raspberry Pi](https://www.raspberrypi.org) (commonly abbreviated to *RPi* or just *pi*). At the moment it's an RPi 3 running _Raspbian 8.0 (jessie)_, but previously it was an RPi 2 that worked just as well.

```
    .',;:cc;,'.    .,;::c:,,.    
   ,ooolcloooo:  'oooooccloo:    OS: Raspbian 8.0 jessie
   .looooc;;:ol  :oc;;:ooooo'    Kernel: armv7l Linux 4.9.35-v7+
     ;oooooo:      ,ooooooc.     Uptime: 60d 18h 19m
       .,:;'.       .;:;'.       Packages: 1459
       .... ..'''''. ....        Shell: 21232
     .''.   ..'''''.  ..''.      CPU: ARMv7 rev 4 (v7l) @ 1.2GHz
     ..  .....    .....  ..      RAM: 124MB / 859MB
    .  .'''''''  .''''''.  .    
  .'' .''''''''  .'''''''. ''.  
  '''  '''''''    .''''''  '''  
  .'    ........... ...    .'.  
    ....    ''''''''.   .''.    
    '''''.  ''''''''. .'''''    
     '''''.  .'''''. .'''''.    
      ..''.     .    .''..      
            .'''''''            
             ......       
```

I don't have a screen attached to it - everything is done over ssh.

I have a [Pi NoIR](https://www.raspberrypi.org/products/pi-noir-camera-v2) camera aimed at the catflap, and an independently powered 12V infrared LED array hot-glued to the wall so I can catch any midnight shenanigans.

<video autoplay="" muted="" loop="">
        <source src="http://s3.eu-west-2.amazonaws.com/isthecatin-images/cat_1505766947_1002002-1.mp4" type="video/mp4">
        this is a video, and apparently your browser doesn't support that.
</video>

...like getting trapped in our washing
{:.caption}

The buzzer is there literally just so I can annoy my housemates by making it beep repeatedly while I'm at work and they're not. I'm a good friend.

<video autoplay="" muted="" loop="">
        <source src="/assets/images/video-1502711527.mp4" type="video/mp4">
        this is a video, and apparently your browser doesn't support that.
</video>


## software
I used Python 3.6 to write the monitoring program. I'm in the process of doing an almost complete rewrite of the code to make it way more extensible and user-friendly, but in all fairness the kinda hacky code I've got running at the moment has been going for several months without too many issues. Crashes are generally due to our shitty Internet connection dropping out at an inopportune moment or because one of my housemates has accidentally unplugged the pi so they can use the iron.

These are a few libraries/modules that are particularly important in the program:

name | notes
--|--
[opencv](https://opencv.org) | this is the heart of the program; I use it to detect motion in the camera's field of view. I won't lie, this was a _bitch_ to install on the Pi. If you're running it on anything except ARM architecture (like a Pi), the [opencv-python](https://github.com/skvark/opencv-python) package is excellent.
[boto](https://github.com/boto/boto) | (not boto3 yet) for uploading to Amazon S3.
[requests](http://docs.python-requests.org) | primarily for sending notifications to [Telegram](https://telegram.org) via [IFTTT](https://ifttt.com) webhooks.
[picamera](https://picamera.readthedocs.io) | controlling the Pi NoIR camera.

I referred to [Adrian Rosebrock's tutorials](https://www.pyimagesearch.com/2015/05/25/basic-motion-detection-and-tracking-with-python-and-opencv) a lot while writing the initial code.

### how it works: an overview

![a series of comparisons](/assets/images/stages.gif)

When the program runs, the `MotionDetector` class starts capturing frames as [`numpy`](http://numpy.org) arrays.

An empty RGB array is constructed:

```python
empty_frame = PiRGBArray(self.cam, size = self.cam.resolution)
```

And that array is reused repeatedly as new frames are captured:

```python
for f in self.cam.capture_continuous(empty_frame, format="bgr", use_video_port=True):
    # --- <frame processing here> ---
    if motion_detected:
      video_frames.append(f)  # save the frame if it's relevant
    empty_frame.truncate(0)  # empty the frame
```

Motion is detected using _background subtraction_. Ultimately, this just means working out what's changed between this frame and the past few frames.

Stuff moves around a lot in my house. The catflap is in the conservatory by the back door, so drying clothes and muddy shoes are constantly moving in and out of shot. And, of course, light changes are very noticeable in a transparent room. If I didn't account for this, every time the sun went down the camera would be _[freaking out](https://xkcd.com/1391)_.

There are a few things the program does when constructing the **background** and comparing frames to help reduce the effects of all the tiny irrelevant details.

The **comparison frame** is:
1. Converted to greyscale.
2. Gaussian blurred to filter out some of the minor details.

Then the **background** is created by overlaying the **comparison frame** onto the previous **background**.

   ```python
   greyscale_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
   blurred_frame = cv2.GaussianBlur(greyscale_frame, (21, 21), 0)
   cv2.accumulateWeighted(greyscale_frame, current_background, 0.5)
   ```

![a gif of 50 different backgrounds](/assets/images/bgs.gif)

I save the background every time I stop the program; here's how the background has changed over the past 8 months
{:.caption}

Movement is detected by looking for areas where the **comparison frame** differs from the **background**.

1. Calculate pixel-by-pixel luminosity deltas
2. Isolate areas where the difference is above a certain threshold
3. Expand the areas slightly
4. Detect contours/edges

```python
frame_delta = cv2.absdiff(blurred,
                          cv2.convertScaleAbs(background))

frame_threshold = cv2.threshold(frame_delta,
                                50,
                                255,
                                cv2.THRESH_BINARY)[1]

frame_expanded = cv2.dilate(frame_threshold,
                            None,
                            iterations=10)

im2, contours, hier = cv2.findContours(frame_expanded,
                                       cv2.RETR_TREE,
                                       cv2.CHAIN_APPROX_SIMPLE)
```

The smaller contours are then filtered out - this stops the program being triggered by tiny movements like a tree rustling in the distance.

```python
large_contours = [c for c in contours if cv2.contourArea(c) >= min_area]
```

If there are any contours remaining above the `min_area` threshold size, it starts saving frames (the **current frame**, not the **comparison frame**). There are some tolerance and file size settings - e.g. a minimum/maximum number of frames per video, a maximum number of continuous frames without motion that counts as _motion ended_ - but once it senses that nothing is moving any longer it stops.

The saved frames are then written to a video file using opencv, and that file is uploaded to various services.

Then, of course, I get a notification on my phone, and I can sit at work in quiet despair knowing that there's a mouse currently being devoured under my dining room table.
