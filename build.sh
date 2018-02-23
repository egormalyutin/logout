#!/bin/bash
echo 'Starting watch!'
chokidar './*.moon' -c 'moonc {path}'
