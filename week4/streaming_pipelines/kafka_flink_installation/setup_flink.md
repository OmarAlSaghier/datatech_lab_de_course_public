# Setup and Install Apache Flink

* Download Apache Flink
```
wget https://dlcdn.apache.org/flink/flink-1.16.0/flink-1.16.0-bin-scala_2.12.tgz
```

* Unzip flink tar file
```
tar xzf flink-1.16.0-bin-scala_2.12.tgz
```

* Move to `/opt` directory
```
sudo mv -f flink-1.16.0 /opt/
```

* Create soft link (Alias name)
```
$ cd /opt/
$ sudo ln -s flink-1.16.0/ flink
```

* Start flink cluster
```
$ cd /opt/flink/
$ ./bin/start-cluster.sh
```
=> go to `localhost:8081` to access flink webUI

* Submit the first job using the `WordCount` exmaple provided with Flink examlpes directory
```
$ cd /opt/flink
$ ./bin/flink run examples/batch/WordCount.jar \
    --input ~/Desktop/<any_text_file> \
    --output ~/Desktop/output.txt
```

***
* Add this section to your `.bashrc` file
```
# Flink
export FLINK_HOME=/opt/flink
export PATH=$PATH:${FLINK_HOME}/bin
```

* Reload `.bashrc`
```
source .bashrc
```

ref: https://www.tutorialspoint.com/apache_flink/apache_flink_running_program.htm
