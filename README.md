# ocr-test
Docker image that contains the dependencies in order to call tesseract from Apache-Spark via javaccp-presets.

First load the docker image for the base image :
 docker load -i Fedora-Docker-Base-24-1.2.x86_64.tar.xz

Then build and run the image.


To go further: 
* https://github.com/tesseract-ocr/tesseract/wiki/APIExample
* https://github.com/bytedeco/javacpp-presets/tree/master/tesseract