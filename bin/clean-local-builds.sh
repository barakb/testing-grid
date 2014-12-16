#!/bin/bash
find ../local-builds/ -maxdepth 1 -name build_* -type d |  sort | head -n -1 | xargs rm -rf
