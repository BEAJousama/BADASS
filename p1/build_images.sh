#!/bin/sh

docker build -t host:v1 -f _obeaj-1_host .

docker build -t router:v1 -f _obeaj-2 .
