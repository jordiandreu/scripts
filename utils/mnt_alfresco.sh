#!/bin/bash
# IMPORTANT: source this file instead of just execute it!!

if [ -z $ALFRESCO_HOME ]; then
echo "Alfresco site has not been mapped as a network device yet."
ALFRESCO_HOME="/alfresco"
echo "Defining mounting point as: $ALFRESCO_HOME"
export ALFRESCO_HOME
fi



if [ -d $ALFRESCO_HOME ]; then
echo "WARNING: folder $ALFRESCO_HOME already exists!"
echo "removing folder..."
sudo umount $ALFRESCO_HOME
sudo rmdir $ALFRESCO_HOME
fi
echo "creating folder..."
sudo mkdir $ALFRESCO_HOME
sudo ln -s $ALFRESCO_HOME /home/$USER/alfresco

sudo mount -t cifs //alfresco.cells.es/alfresco/sites $ALFRESCO_HOME -o username=$USER,rw
#echo "Mounting Alfresco Site: SUCCESS"
