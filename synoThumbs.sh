#!/bin/bash
# Author:	phillips321 contact through phillips321.co.uk
# Updated: 
# License:	CC BY-SA 3.0
# Use:		
# Released:	www.phillips321.co.uk
    version=1.1

# ChangeLog:
# v1.1 - now supports photo thumbnails generation for ds 4.1
#	v1.0 - now supports video conversion (mov and avi)
#		- for more formats please contact me with requests as i dont have any sample mpg etc
#		- ffmpeg output is surpressed (>/dev/null)
#	v0.1 - first release

# picture thumbnail filenames & size
Xname="SYNOPHOTO:THUMB_XL.jpg";   Xsize="1280x1280";
Lname="SYNOPHOTO:THUMB_L.jpg" ;   Lsize="800x800";
Bname="SYNOPHOTO:THUMB_B.jpg" ;   Bsize="640x640";
Mname="SYNOPHOTO:THUMB_M.jpg" ;   Msize="320x320";
Sname="SYNOPHOTO:THUMB_S.jpg" ;   Ssize="120x120";

# video thumbnail filenames & size
V_Hname="SYNOPHOTO:FILM_H.mp4" ;       V_Hsize="1280x1280";
V_H264name="SYNOPHOTO:FILM_H264.mp4" ; V_H264size="1280x1280";
V_Lname="SYNOPHOTO:FILM_L.mp4" ;       V_Lsize="800x800";
V_Mname="SYNOPHOTO:FILM_M.mp4" ;       V_Msize="320x320";
V_MOBname="SYNOPHOTO:FILM_S.mp4" ;     V_MOBsize="160x160";

ORIGIFS=$IFS ; IFS=$(echo -en "\n\b")

# intro
makeline(){ printf '%*s\n' "${1:-${COLUMNS:-$(tput cols)}}" "" | tr " " "${2:-#}"; }
makeline; echo " Welcome to synoThumb.sh version $version"; echo " This script creates the thumbs for a synology"; makeline;

# help message
if [[ $# == 0 ]] ; then makeline; echo " Error: What directory to process?"; echo " Usage: $0 ."; makeline ; exit 1; fi

############### thumbnails generation for pictures ######################
#########################################################################
for i in `find ${1} \( -type f -a \( -name "*.JPG" -o -name "*.jpg" -o -name "*.png" -o -name "*.PNG" -o -name "*.jpeg" -o -name "*.JPEG" \) ! -path "*@eaDir*" \)`
do
  picName=`echo "${i}" |  awk -F\/ '{print $NF}'`
  picDir=`echo "${i}" | sed s/"${picName}"//g | sed s/.$//`

  echo "Searching Thumbs For $i"

  # Create directory if does not exist
  [[ !(-d "$picDir"/"@eaDir"/"$picName") ]] && (mkdir -p "$picDir""/@eaDir/""$picName"; chmod 775 "$picDir"/"@eaDir"/"$picName";)

  # Generate thumbnails if don't exist
  # TODO: add quality
  # TODO: use -scale, -sample instead of -resize
  # TODO: Add timestamps check. Regenerate thumbnails only for updated files (file.updatetime > thumbnail.creationtime)
  [[ !(-f "$picDir"/"@eaDir"/"$picName"/"$Xname") ]] && (convert -size $Xsize "$picDir""/""$picName" -resize $Xsize -auto-orient -quality 85 "$picDir""/@eaDir/""$picName""/""$Xname"; echo "  -- "$Xname" thumbnail created";)
  [[ !(-f "$picDir"/"@eaDir"/"$picName"/"$Lname") ]] && (convert -size $Lsize "$picDir""/""$picName" -resize $Lsize -auto-orient -quality 80 "$picDir""/@eaDir/""$picName""/""$Lname"; echo "  -- "$Lname" thumbnail created";)
  [[ !(-f "$picDir"/"@eaDir"/"$picName"/"$Bname") ]] && (convert -size $Bsize "$picDir""/""$picName" -resize $Bsize -auto-orient -quality 80 "$picDir""/@eaDir/""$picName""/""$Bname"; echo "  -- "$Bname" thumbnail created";)
  [[ !(-f "$picDir"/"@eaDir"/"$picName"/"$Mname") ]] && (convert -size $Msize "$picDir""/""$picName" -resize $Msize -auto-orient -quality 50 "$picDir""/@eaDir/""$picName""/""$Mname"; echo "  -- "$Mname" thumbnail created";)
  [[ !(-f "$picDir"/"@eaDir"/"$picName"/"$Sname") ]] && (convert -size $Ssize "$picDir""/""$picName" -resize $Ssize -auto-orient -quality 50 "$picDir""/@eaDir/""$picName""/""$Sname"; echo "  -- "$Sname" thumbnail created";)
done

############### thumbnails generation for videos ########################
#########################################################################

## MOV files
# for i in `find ${1} \( -type f -a \( -name "*.MOV" -o -name "*.mov" \) ! -path "*@eaDir*" \)`
# do
#   vidName=`echo "${i}" |  awk -F\/ '{print $NF}'`
#   vidDir=`echo "${i}" | sed s/"${vidName}"//g | sed s/.$//`
#   [[ !(-d "$vidDir"/"@eaDir"/"$vidName") ]] && (mkdir -p "$vidDir""/@eaDir/""$vidName"; chmod 775 "$vidDir"/"@eaDir"/"$vidName";)

#   # generating videos
#   # if some of the formats is not needed, comment corresponding line below
#   echo "Searching video conversions for $i"
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$V_Hname") ]] &&    ( echo "   -- processing "$vidName ; ffmpeg -i "$vidDir""/""$vidName" -s V_Hsize -f flv -deinterlace -ab 64k -acodec mpga -ar 44100 "$vidDir"/"@eaDir"/"$vidName"/"$V_Hname" 2> /dev/null ; echo "   -- "$vidName "HIGH quality created";)
#   # [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$V_H264name") ]] && ( echo "   -- processing "$vidName ; ffmpeg -i "$vidDir""/""$vidName" -s V_H264size -f flv -deinterlace -ab 64k -acodec libmp3lame -ar 44100 "$vidDir"/"@eaDir"/"$vidName"/"$V_H264name" 2> /dev/null ; echo "   -- "$vidName "h264 created";)
#   # [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$V_Lname") ]] &&    ( echo "   -- processing "$vidName ; ffmpeg -i "$vidDir""/""$vidName" -s V_Lsize -f flv -deinterlace -ab 64k -acodec libmp3lame -ar 44100 "$vidDir"/"@eaDir"/"$vidName"/"$V_Lname" 2> /dev/null ; echo "   -- "$vidName "LOW quality created";)
#   # [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$V_Mname") ]] &&    ( echo "   -- processing "$vidName ; ffmpeg -i "$vidDir""/""$vidName" -s V_Msize -f flv -deinterlace -ab 64k -acodec libmp3lame -ar 44100 "$vidDir"/"@eaDir"/"$vidName"/"$V_Mname" 2> /dev/null ; echo "   -- "$vidName "MEDIUM quality created";)
#   # [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$V_MOBname") ]] &&    ( echo "   -- processing "$vidName ; ffmpeg -i "$vidDir""/""$vidName" -s V_MOBsize -f flv -deinterlace -ab 64k -acodec libmp3lame -ar 44100 "$vidDir"/"@eaDir"/"$vidName"/"$V_MOBname" 2> /dev/null ; echo "   -- "$vidName "MOBILE quality created";)

#   # generating thumbnails
#   echo "Searching Thumbs For $i"
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$XLname") ]] && (ffmpeg -i "$vidDir""/""$vidName" -an -ss 00:00:03 -an -r 1 -vframes 1 "$vidDir"/"@eaDir"/"$vidName"/"$XLname" 2> /dev/null ; echo "   -- "$XLname" thumbnail created";)
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$Lname") ]] && (convert -size $XLsize "$vidDir""/@eaDir/""$vidName""/""$XLname" -auto-orient -resize $Lsize "$vidDir""/@eaDir/""$vidName""/""$Lname"; echo "   -- "$Lname" thumbnail created";)
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$Bname") ]] && (convert -size $Lsize "$vidDir""/@eaDir/""$vidName""/""$Lname" -auto-orient -resize $Bsize "$vidDir""/@eaDir/""$vidName""/""$Bname"; echo "   -- "$Bname" thumbnail created";)
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$Mname") ]] && (convert -size $Bsize "$vidDir""/@eaDir/""$vidName""/""$Bname" -auto-orient -resize $Msize "$vidDir""/@eaDir/""$vidName""/""$Mname"; echo "   -- "$Mname" thumbnail created";)
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$Sname") ]] && (convert -size $Msize "$vidDir""/@eaDir/""$vidName""/""$Mname" -auto-orient -quality 60 -resize $Ssize "$vidDir""/@eaDir/""$vidName""/""$Sname"; echo "   -- "$Sname" thumbnail created";)
# done

## AVI and MP4 files
# for i in `find ${1} \( -type f -a \( -name "*.AVI" -o -name "*.avi" -o -name "*.mp4" -o -name "*.MP4" \) ! -path "*@eaDir*" \)`
# do
#   vidName=`echo "${i}" |  awk -F\/ '{print $NF}'`
#   vidDir=`echo "${i}" | sed s/"${vidName}"//g | sed s/.$//`
#   [[ !(-d "$vidDir"/"@eaDir"/"$vidName") ]] && (mkdir -p "$vidDir""/@eaDir/""$vidName"; chmod 775 "$vidDir"/"@eaDir"/"$vidName";)

#   # generating videos
#   echo "Searching video conversions for $i"
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/'SYNOPHOTO:FILM_M.mp4') ]] && ( echo "   -- processing "$vidName ; fmpeg -i "$vidDir""/""$vidName" -vcodec libx264 -vpre medium -ar 44100 "$vidDir"/"@eaDir"/"$vidName"/'SYNOPHOTO:FILM_M.mp4' 2> /dev/null ; echo  "   -- "$vidName "mp4 created";)
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/'SYNOPHOTO:FILM_MOBILE.mp4') ]] && ( echo "   -- processing "$vidName ; ffmpeg -i "$vidDir""/""$vidName" -vcodec libx264 -vpre medium -ar 44100 -s 320x240 "$vidDir"/"@eaDir"/"$vidName"/'SYNOPHOTO:FILM_MOBILE.mp4' 2> /dev/null ; echo  "   -- "$vidName "mobile mp4 created";)

#   # generating thumbnails
#   echo "Searching Thumbs For $i"
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$XLname") ]] && (ffmpeg -i "$vidDir""/""$vidName" -an -ss 00:00:03 -an -r 1 -vframes 1 "$vidDir"/"@eaDir"/"$vidName"/"$XLname" 2> /dev/null ; echo "   -- "$XLname" thumbnail created";)
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$Lname") ]] && (convert -size $XLsize "$vidDir""/@eaDir/""$vidName""/""$XLname" -auto-orient -resize $Lsize "$vidDir""/@eaDir/""$vidName""/""$Lname"; echo "   -- "$Lname" thumbnail created";)
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$Bname") ]] && (convert -size $Lsize "$vidDir""/@eaDir/""$vidName""/""$Lname" -auto-orient -resize $Bsize "$vidDir""/@eaDir/""$vidName""/""$Bname"; echo "   -- "$Bname" thumbnail created";)
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$Mname") ]] && (convert -size $Bsize "$vidDir""/@eaDir/""$vidName""/""$Bname" -auto-orient -resize $Msize "$vidDir""/@eaDir/""$vidName""/""$Mname"; echo "   -- "$Mname" thumbnail created";)
#   [[ !(-f "$vidDir"/"@eaDir"/"$vidName"/"$Sname") ]] && (convert -size $Msize "$vidDir""/@eaDir/""$vidName""/""$Mname" -auto-orient -quality 60 -resize $Ssize "$vidDir""/@eaDir/""$vidName""/""$Sname"; echo "   -- "$Sname" thumbnail created";)
# done

# exit message
makeline; echo " After uploading the photos&videos, log into DSM and launch reindexing"; echo " (Control Panel --> Media Indexing Service --> Re-index)"; makeline;

# TODO: Ideally there should be a scipt for uploading the files with rsync
# and launching the diskstation indexer specifially for the uploaded files/folders

IFS=$ORIGIFS;
exit 0