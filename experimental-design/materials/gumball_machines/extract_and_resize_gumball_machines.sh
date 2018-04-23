#!/bin/bash


for i in $(seq 1 10)
do
  for p in 0 10 25 40 50 60 75 90 100
  do
  
    convert -crop 215x290+433+45 ../$i/scene_blue_video_$p.png tmp.png
    convert -fill '#ffffff' -draw 'rectangle 194,158,215,224' -fill '#ffffff' -draw 'rectangle 206,136,215,158' -draw 'rectangle 198,150,202,158' -draw 'rectangle 202,145,206,158'   tmp.png tmp2.png
    convert -resize 86x116 tmp2.png gumball_${p}_${i}.png
  done
done

for p in 0 10 25 40 50 60 75 90 100
do
  convert -size 86x116 -page 86x116+0+0 -delay 60 gumball_${p}_*.png gumball_${p}.gif
done

rm tmp*.png