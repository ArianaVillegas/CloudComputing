FROM ubuntu:14.04

# Setup Java
RUN set -x && \
    apt-get update && \
    apt-get install -y curl openjdk-7-jdk python2.7 python-pip && \
    apt-get clean && \
    apt-get autoremove && \
    rm -rf /var/cache/apk/* /var/lib/apt/lists/* && \
    update-java-alternatives -s java-1.7.0-openjdk-amd64 && \
    (find /usr/share/doc -type f -and -not -name copyright -print0 | xargs -0 rm) && \
    java -version
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

ARG HADOOP_VERSION=2.6
ARG SPARK_VERSION=1.5.2

# Setup Spark
ENV SPARK_HOME=/opt/spark-${SPARK_VERSION}
ENV PYSPARK_PYTHON=python
ENV PATH=$PATH:${SPARK_HOME}/bin


# Set up Sqoop
ENV SQOOP_HOME /opt/sqoop
ENV PATH ${PATH}:${SQOOP_HOME}/bin:${HADOOP_HOME}/bin

# Download Spark using curl
RUN curl -o spark.tgz https://archive.apache.org/dist/spark/spark-1.5.2/spark-1.5.2-bin-hadoop2.6.tgz && \
    tar -xzf spark.tgz -C /opt && \
    rm spark.tgz


# Set environment variables for Spark and add it to PATH
ENV SPARK_HOME /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ENV PATH $PATH:${SPARK_HOME}/bin

# Download Pyspark 1.5.2 manually and install it from a local file
ENV PYSPARK_PYTHON=python

# Command to run your Pyspark application
CMD ["spark-submit", "/src/wordcount.py"]
