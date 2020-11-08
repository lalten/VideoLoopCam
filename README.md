# VideoLoopCam

A bunch of scripts to gain privacy and/or prank your remote coworkers. Should work with most if not all programs, including Chrome, Zoom.

## Setup
YMMV. This could work for Ubuntu.:
```sh
sudo apt install ffmpeg v4l2loopback-dkms bc mpv v4l-utils
git clone https://github.com/lalten/VideoLoopCam.git
cd VideoLoopCam
chmod +x *.sh
```

## Use cases

### I have a video that I want to use as webcam
Perfect, just run `play.sh`

### I have a video but it does not loop nicely
`loop.sh` should make your life a tiny bit easier.

### I also need to record a video
`record.sh` will help you record from your webcam. It displays a preview where the first frame is transparently overlayed. If you end your video with everything in the same position as in the overlay, it will make a more seamless loop.

## Ingredients
Built with:
 * [v4l2loopback - a kernel module to create V4L2 loopback devices](https://github.com/umlaeute/v4l2loopback)
 * [FFmpeg. A complete, cross-platform solution to record, convert and stream audio and video](https://ffmpeg.org/)

More (mostly optional) dependencies:
 * `bc`
 * `mpv`
 * `v4l2-ctl`
