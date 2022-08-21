FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev  
RUN git clone https://github.com/ukoethe/vigra.git
WORKDIR /vigra
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ .
RUN make
RUN make install
RUN mkdir /vigraCorpus
RUN cp ./src/examples/*.gif /vigraCorpus
RUN afl-clang++ -I/usr/local/include/vigra ./src/examples/convert.cxx -o /convert -lvigraimpex
ENV LD_LIBRARY_PATH=/usr/local/lib/

ENTRYPOINT ["afl-fuzz", "-i", "/vigraCorpus", "-o", "/vigraOut"]
CMD ["/convert", "@@", "out.gif"]
