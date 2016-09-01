FROM fedora-docker-base-24-1.2.x86_64
MAINTAINER aar

# Install dependencies
RUN dnf -y install automake autoconf libtool zlib-devel  libjpeg-devel giflib libtiff-devel libwebp libwebp-devel libicu-devel openjpeg-devel cairo-devel git sudo java-1.8.0-openjdk-devel.x86_64 maven make gcc-c++ nasm

# Clone the fork
RUN git clone https://github.com/AndreiArion/javacpp-presets.git

# Install configure leptonica
RUN cd javacpp-presets;./cppbuild.sh install leptonica
RUN cd javacpp-presets/leptonica/cppbuild/linux-x86_64/leptonica-1.73/;LDFLAGS="-Wl,-rpath -Wl,/usr/local/lib" ./configure;make;sudo make install
RUN cd javacpp-presets/leptonica/;mvn clean install

# Install configure tesseract
RUN cd javacpp-presets/tesseract; ./cppbuild.sh install tesseract;
RUN cd javacpp-presets/tesseract/cppbuild/linux-x86_64/tesseract-3.04.01;LDFLAGS="-Wl,-rpath -Wl,/usr/local/lib" ./configure
RUN cd javacpp-presets/tesseract; make &amp;&amp; make install
RUN cd ../../../
RUN mvn clean install
RUN cd ..