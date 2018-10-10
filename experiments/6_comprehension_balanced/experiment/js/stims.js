
var percentages = [0, 10, 25, 40, 50, 60, 75, 90, 100];

var attention_check_positions = [
	{"top": "220px", "left": "310px"},
	{"top": "100px", "left": "60px"},
	{"top": "160px", "left": "200px"},
	{"top": "150px", "left": "275px"},
	{"top": "355px", "left": "100px"},
	{"top": "270px", "left": "40px"},
	{"top": "325px", "left": "275px"},
	{"top": "325px", "left": "225px"},
	{"top": "400px", "left": "275px"}
];


var colors = ["blue", "orange"];
var modals = ["bare", "might", "probably"];


var exposure_trials_might = []

var exposure_trials_probably = []

var exp_catch_trial_idxs = _.sample(_.range(25), 6);



//probably biased

// 10 critical trials with orange and blue 60%
for (var i = 0; i < 10; i++) {
	var t_idx = exposure_trials_probably.length;
	var col = _.sample(colors);
	var p = col == "orange" ? "40" : "60";
	var trial = {
		"catch_trial": (exp_catch_trial_idxs.indexOf(t_idx) > -1),
		"image": "scene_" + col + "_video_" + p + ".gif",
		"video": col + "_probably_" + SPEAKER_CONDITION,
		"modal": "probably",
		"color": col,
		"percentage_blue": p
	}
	exposure_trials_probably.push(trial);
}	


// 5 critical trials with orange and blue 100%
for (var i = 0; i < 5; i++) {
	var t_idx = exposure_trials_probably.length;
	var col = _.sample(colors);
	var p = col == "orange" ? "0" : "100";
	var trial = {
		"catch_trial": (exp_catch_trial_idxs.indexOf(t_idx) > -1),
		"image": "scene_" + col + "_video_" + p + ".gif",
		"video": col + "_bare_" + SPEAKER_CONDITION,
		"modal": "bare",
		"color": col,
		"percentage_blue": p
	}
	exposure_trials_probably.push(trial);
}

// 10 critical trials with orange and blue 75%
for (var i = 0; i < 10; i++) {
	var t_idx = exposure_trials_probably.length;
	var col = _.sample(colors);
	var p = col == "orange" ? "75" : "25";
	var trial = {
		"catch_trial": (exp_catch_trial_idxs.indexOf(t_idx) > -1),
		"image": "scene_" + col + "_video_" + p + ".gif",
		"video": col + "_might_" + SPEAKER_CONDITION,
		"modal": "might",
		"color": col,
		"percentage_blue": p
	}
	exposure_trials_probably.push(trial);
}	

/////// might biased

// 10 critical trials with orange and blue 60%
for (var i = 0; i < 10; i++) {
	var t_idx = exposure_trials_might.length;
	var col = _.sample(colors);
	var p = col == "orange" ? "40" : "60";
	var trial = {
		"catch_trial": (exp_catch_trial_idxs.indexOf(t_idx) > -1),
		"image": "scene_" + col + "_video_" + p + ".gif",
		"video": col + "_might_" + SPEAKER_CONDITION,
		"modal": "might",
		"color": col,
		"percentage_blue": p
	}
	exposure_trials_might.push(trial);
}	


// 5 critical trials with orange and blue 100%
for (var i = 0; i < 5; i++) {
	var t_idx = exposure_trials_might.length;
	var col = _.sample(colors);
	var p = col == "orange" ? "0" : "100";
	var trial = {
		"catch_trial": (exp_catch_trial_idxs.indexOf(t_idx) > -1),
		"image": "scene_" + col + "_video_" + p + ".gif",
		"video": col + "_bare_" + SPEAKER_CONDITION,
		"modal": "bare",
		"color": col,
		"percentage_blue": p
	}
	exposure_trials_might.push(trial);
}

// 10 critical trials with orange and blue 90%
for (var i = 0; i < 10; i++) {
	var t_idx = exposure_trials_might.length;
	var col = _.sample(colors);
	var p = col == "orange" ? "10" : "90";
	var trial = {
		"catch_trial": (exp_catch_trial_idxs.indexOf(t_idx) > -1),
		"image": "scene_" + col + "_video_" + p + ".gif",
		"video": col + "_probably_" + SPEAKER_CONDITION,
		"modal": "probably",
		"color": col,
		"percentage_blue": p
	}
	exposure_trials_might.push(trial);
}	


exposure_trials = {
	"might": exposure_trials_might,
	"probably": exposure_trials_probably
}

