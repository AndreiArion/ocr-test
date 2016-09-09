FROM fedora-docker-base-24-1.2.x86_64
MAINTAINER aar

# Install dependencies
RUN dnf -y install automake autoconf libtool zlib-devel  libjpeg-devel giflib libtiff-devel libwebp libwebp-devel libicu-devel openjpeg-devel cairo-devel git sudo java-1.8.0-openjdk-devel.x86_64 maven make gcc-c++ nasm

# Clone the fork
RUN echo "modified1"
RUN git clone https://github.com/AndreiArion/javacpp-presets.git
RUN cd javacpp-presets; git checkout origin/1.22

# Install configure leptonica
RUN cd javacpp-presets;./cppbuild.sh install leptonica
RUN cd javacpp-presets/leptonica/cppbuild/linux-x86_64/leptonica-1.73/;LDFLAGS="-Wl,-rpath -Wl,/usr/local/lib" ./configure;make;sudo make install
RUN cd javacpp-presets/leptonica/;mvn clean install

# Install configure tesseract
RUN cd javacpp-presets/tesseract; ./cppbuild.sh install tesseract;
RUN cd javacpp-presets/tesseract/cppbuild/linux-x86_64/tesseract-3.04.01;LDFLAGS="-Wl,-rpath -Wl,/usr/local/lib" ./configure
RUN cd javacpp-presets/tesseract/cppbuild/linux-x86_64/tesseract-3.04.01; make ; make install
RUN cd javacpp-presets/tesseract/; mvn clean install

# Install configure ghostscript
RUN curl http://downloads.ghostscript.com/public/old-gs-releases/ghostscript-9.16.tar.gz > ghostscript-9.16.tar.gz; tar zxvf ghostscript-9.16.tar.gz

RUN cd ghostscript-9.16 ;./autogen.sh && ./configure --prefix=/usr --disable-compile-inits  --enable-dynamic && sudo make && make soinstall && install -v -m644 base/*.h /usr/include/ghostscript && ln -v -s ghostscript /usr/include/ps && sudo ln -sf /usr/lib/libgs.so /usr/local/lib/libgs.so

# Configure jars for spark
RUN  cd /javacpp-presets/target ; for i in `ls *`; do export MY_JARS=/javacpp-presets/target/$i,$MY_JARS; done; echo $MY_JARS

# Download/unzip Spark

RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-1.6.1-bin-hadoop2.6.tgz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-1.6.1-bin-hadoop2.6 spark
ENV SPARK_HOME /usr/local/spark


# Traindata for tesseract
RUN git clone https://github.com/tesseract-ocr/tessdata.git

#ENTRYPOINT /usr/local/spark/bin/spark-shell  --jars /javacpp-presets/target/tesseract.jar,/javacpp-presets/target/tesseract-linux-x86_64.jar,/javacpp-presets/target/leptonica.jar,/javacpp-presets/target/leptonica-linux-x86_64.jar,/javacpp-presets/target/javacpp.jar  --conf spark.executorEnv.TESSDATA_PREFIX=/
