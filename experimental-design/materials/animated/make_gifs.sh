
for i in 0 10 25 40 50 60 75 90 100
do
for col in orange blue
do
convert -delay 60 -size 600x450 ../1/scene_${col}_video_${i}.png ../2/scene_${col}_video_${i}.png ../3/scene_${col}_video_${i}.png ../4/scene_${col}_video_${i}.png ../5/scene_${col}_video_${i}.png ../6/scene_${col}_video_${i}.png ../7/scene_${col}_video_${i}.png ../8/scene_${col}_video_${i}.png ../9/scene_${col}_video_${i}.png ../10/scene_${col}_video_${i}.png scene_${col}_video_${i}.gif

convert -resize 600x450 scene_${col}_video_${i}.gif scene_${col}_video_${i}.gif.2
mv scene_${col}_video_${i}.gif.2 scene_${col}_video_${i}.gif

done
done
