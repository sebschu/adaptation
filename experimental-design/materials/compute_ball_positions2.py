#!/usr/bin/env python3

import numpy as np
import sys
from random import shuffle
from subprocess import call


POSSIBLE_REGIONS=[
	{"x": 466, "w": 145, "y": 97, "h": 113},
	{"x": 482, "w": 113, "y": 212, "h": 19},
	{"x": 511, "w": 64, "y": 231, "h": 10},
	{"x": 450, "w": 26, "y": 127, "h": 61},
	{"x": 598, "w": 27, "y": 118, "h": 80},
]


BALL_SIZE = 18

NUM_BALLS = 30


def compute_candidate_topleft_points(free_pixels):
	possible_topleft_points = []
	for i in range(0, 800-BALL_SIZE):
		for j in range(0, 600-BALL_SIZE):
			if np.sum(free_pixels[i:i+BALL_SIZE,j:j+BALL_SIZE]) == BALL_SIZE**2:
				possible_topleft_points.append((i,j))
			
	return possible_topleft_points
	



free_pixels = np.zeros((800,600), dtype=bool)

for r in POSSIBLE_REGIONS:
	free_pixels[r["x"]:r["x"]+r["w"],r["y"]:r["y"]+r["h"]] = True



positions = []

for i in range(NUM_BALLS):
	candidates = np.array(compute_candidate_topleft_points(free_pixels), dtype=[('a','<i4'),('b','<i4')])
	if len(candidates) < 1:
		print("ERRROR, no candidates!")
		sys.exit(1)
		
	pos = np.random.choice(candidates)
	positions.append(pos)
	x,y =pos
	free_pixels[x:x+BALL_SIZE-2,y:y+BALL_SIZE-2] = False


perc_blue = float(sys.argv[1])
n_blue = int(NUM_BALLS * perc_blue / 100)
n_orange = NUM_BALLS - n_blue

colors = (["blue"] * n_blue) + (["orange"] * n_orange)
shuffle(colors)

prev_img = "scene_empty_blue_video.png"
for i, x in enumerate(zip(positions, colors)):
	pos, col = x
	print(pos)
	command = ["magick", "composite", "-gravity",  "NorthWest", "-geometry",  "+%d+%d" % (pos[0], pos[1]), "-compose", "atop", "ball_%s.png" % col, prev_img, "test_%d.png" % i]
	prev_img = "test_%d.png" % i
	call(command)

command = ["mv", prev_img, "scene_blue_video_%d.png" % int(perc_blue)]
call(command)


prev_img = "scene_empty_orange_video.png"
for i, x in enumerate(zip(positions, colors)):
	pos, col = x
	print(pos)
	command = ["magick", "composite", "-gravity",  "NorthWest", "-geometry",  "+%d+%d" % (pos[0], pos[1]), "-compose", "atop", "ball_%s.png" % col, prev_img, "test_%d.png" % i]
	prev_img = "test_%d.png" % i
	call(command)

command = ["mv", prev_img, "scene_orange_video_%d.png" % int(perc_blue)]
call(command)

