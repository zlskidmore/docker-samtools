# work from latest LTS ubuntu release
FROM ubuntu:18.04

# set the environment variables
ENV samtools_version 1.9
ENV bcftools_version 1.9
ENV htslib_version 1.9

# run update and install necessary packages
RUN apt-get update -y && apt-get install -y \
    bzip2 \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libnss-sss \
    libbz2-dev \
    liblzma-dev \
    vim \
    less

# download the suite of tools
ADD https://github.com/samtools/samtools/releases/download/${samtools_version}/samtools-${samtools_version}.tar.bz2 /usr/bin/
ADD https://github.com/samtools/bcftools/releases/download/${bcftools_version}/bcftools-${bcftools_version}.tar.bz2 /usr/bin/
ADD https://github.com/samtools/htslib/releases/download/${htslib_version}/htslib-${htslib_version}.tar.bz2 /usr/bin/

# extract files for the suite of tools
RUN tar -xjf /usr/bin/samtools-${samtools_version}.tar.bz2 -C /usr/bin/
RUN tar -xjf /usr/bin/bcftools-${bcftools_version}.tar.bz2 -C /usr/bin/
RUN tar -xjf /usr/bin/htslib-${htslib_version}.tar.bz2 -C /usr/bin/

# run make on the source
RUN cd /usr/bin/htslib-${htslib_version}/ && ./configure
RUN cd /usr/bin/htslib-${htslib_version}/ && make
RUN cd /usr/bin/htslib-${htslib_version}/ && make install

RUN cd /usr/bin/samtools-${samtools_version}/ && ./configure
RUN cd /usr/bin/samtools-${samtools_version}/ && make
RUN cd /usr/bin/samtools-${samtools_version}/ && make install

RUN cd /usr/bin/bcftools-${bcftools_version}/ && make
RUN cd /usr/bin/bcftools-${bcftools_version}/ && make install

# set default command
CMD ["samtools"]
