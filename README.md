
[![Build Status](https://travis-ci.org/cyber-dojo/differ.svg?branch=master)](https://travis-ci.org/cyber-dojo/differ)

<img src="https://raw.githubusercontent.com/cyber-dojo/nginx/master/images/home_page_logo.png" alt="cyber-dojo yin/yang logo" width="50px" height="50px"/>

# cyberdojo/differ docker image

A micro-service for [cyber-dojo](http://cyber-dojo.org).
A **cyberdojo/differ** docker container runs sinatra on port 4567.
[cyberdojo/web](https://github.cim/cyber-dojo/web) uses cyberdojo/differ to obtain the diff between the
visible files of two traffic-lights.

- - - -

```
./demo.sh
```

Creates two docker images; a diff-client and a diff-server (both using sinatra).
The diff-client sends two sets of files (in a json body) to the diff-server and the diff-server
returns their processed diff. The diff-client runs on port 4568 and the diff-server
on port 4567. If the diff-client's IP address is 192.168.99.100 then put
192.168.99.100:4568 into your browser to see the processed diff.

```
./pipe_build_up_test.sh
```

Rebuilds the images and runs the tests inside the differ server/client containers

...