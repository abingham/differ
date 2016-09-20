
The repo for the cyber-dojo/differ docker image.

```
./demo.sh
```

Creates two docker images; a diff-client and a diff-server (both using sinatra).
The diff-client sends two files (in a json body) to the server and the diff-server
returns their processed diff.

In the demo the diff-client runs on port 4568 and the diff-server on port 4567.
If the diff-client's IP address is 192.168.99.100 then put
192.168.99.100:4568/diff into your browser to see the processed diff.


```
./test.sh
```

Rebuild the images and runs the tests inside the differ server/client containers
