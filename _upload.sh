#!/bin/sh
TAG=`date +"%y%m%d-%H.%M"`
#echo $TAG
docker tag "securebrowsing/proxy-no-auth" "securebrowsing/proxy-no-auth:"$TAG
docker push "securebrowsing/proxy-no-auth:$TAG"
