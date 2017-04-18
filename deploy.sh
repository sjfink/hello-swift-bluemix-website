#!/bin/bash
#
# Copyright 2016 IBM Corp. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the “License”);
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an “AS IS” BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# See https://developer.ibm.com/recipes/tutorials/create-a-static-website-with-ibm-object-storage/
#

WSK='wsk'                      # Set if not in your $PATH
CF='cf'                        # Set if not in your $PATH
JQ='jq'                        # Set if not in your $PATH
SWIFT='/usr/local/bin/swift'   # ObjectStore swift client

OS_INSTANCE='demo-objectstore'
CONTAINER='demo-website'

# Capture the namespace where actions will be created
API_HOST=`$WSK property get --apihost | sed -n -e 's/^whisk API host//p' | tr -d '\t '`
CURRENT_NAMESPACE=`$WSK property get --namespace | sed -n -e 's/^whisk namespace//p' | tr -d '\t '`
if [ $CURRENT_NAMESPACE == '_' ]
then
    CURRENT_NAMESPACE=`$WSK namespace list | tail -1`
fi
echo "API Host is $API_HOST"
echo "Current namespace is $CURRENT_NAMESPACE"

# create and configure a Bluemix ObjectStore instance
function installOS() {
   $CF create-service Object-Storage Free $OS_INSTANCE
}

function install() {
   
   # set environment variables for the object store instance
   $CF create-service-key $OS_INSTANCE for-demo
   key=`$CF service-key $OS_INSTANCE for-demo | sed -e 's/.*\.\.\.//'`
   echo $key
   export OS_USER_ID=`echo $key | $JQ '.userId' | sed -e 's/\"//g'` 
   export OS_PASSWORD=`echo $key | $JQ '.password' | sed -e 's/\"//g'` 
   export OS_PROJECT_ID=`echo $key | $JQ '.projectId' | sed -e 's/\"//g'` 
   export OS_AUTH_URL=https://identity.open.softlayer.com/v3
   export OS_REGION_NAME=`echo $key | $JQ '.region' | sed -e 's/\"//g'` 
   export OS_IDENTITY_API_VERSION=3
   export OS_AUTH_VERSION=3
   echo OS_USER_ID=$OS_USER_ID
   echo OS_PASSWORD=$OS_PASSWORD
   echo OS_PROJECT_ID=$OS_PROJECT_ID
   echo OS_AUTH_URL=$OS_AUTH_URL
   echo OS_REGION_NAME=$OS_REGION_NAME
   echo OS_IDENTITY_API_VERSION=$OS_IDENTITY_API_VERSION
   echo OS_AUTH_VERSION=$OS_AUTH_VERSION

   $SWIFT --version

   # create a container
   $SWIFT post $CONTAINER

   # set index.html as the default file
   $SWIFT post -m 'web-index:index.html' $CONTAINER

   `$SWIFT auth`

   $SWIFT upload $CONTAINER index.html

   # make it publicly readable
   $SWIFT post -r '.r:*' $CONTAINER

   echo $OS_STORAGE_URL/$CONTAINER/index.html
}

function uninstall() {
   echo Uninstall not yet implemented
}


case "$1" in
"--installOS" )
installOS
;;
"--install" )
install
;;
"--uninstall" )
uninstall
;;
* )
usage
;;
esac
