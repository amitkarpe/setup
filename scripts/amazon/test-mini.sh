#!/usr/bin/bash

set -e
#!/bin/bash

# Build
# docker build -t amazon-mini -f Dockerfile-mini .
docker run -it -v $(pwd):/app amazon-mini
#docker run -d --name my-amazon-container amazon-linux-tools
#docker exec -it my-amazon-container /bin/bash