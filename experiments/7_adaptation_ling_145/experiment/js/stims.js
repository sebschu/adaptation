
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
var modals = ["bare", "might", "probably", "could", "looks_like", "think"];
var speakers = ["m", "f"]


var sentences = {
	"blue": {"bare": "You'll get a blue one", 
	         "might": "You might get a blue one",
	         "probably": "You'll probably get a blue one",
	         "could": "You could get a blue one",
	         "looks_like": "It looks like you'll get a blue one",
	         "think": "I think you'll get a blue one"},
	"orange": {"bare": "You'll get an orange one", 
	           "might": "You might get an orange one",
	           "probably": "You'll probably get an orange one",
	           "could": "You could get an orange one",
	           "looks_like": "It looks like you'll get an orange one",
	           "think": "I think you'll get an orange one"}
};

var conditions = []

for (var i = 0; i < modals.length; i++) {
	for (var j = i + 1; j < modals.length; j++) {
		
		var m1 = modals[i];
		var m2 = modals[j];
		conditions.push({
			"pair": [m1, m2],
			"sentences": {
				"blue": [[m1, sentences["blue"][m1]], [m2, sentences["blue"][m2]]],
				"orange": [[m1, sentences["orange"][m1]], [m2, sentences["orange"][m2]]]
			}
		});
	}
}

var exposure_trials_1 = []

var exposure_trials_2 = []

var exp_catch_trial_idxs = _.sample(_.range(40), 12);

function build_exposure_trials(might_trials, prob_trials, speaker_condition) {

  //probably biased

  // 10 critical trials with orange and blue 60%
  for (var i = 0; i < 10; i++) {
  	var t_idx = prob_trials.length;
  	var col = _.sample(colors);
  	var p = col == "orange" ? "40" : "60";
  	var trial = {
  		"catch_trial": (exp_catch_trial_idxs.indexOf(t_idx) > -1) ? 1 : 0,
  		"image": "scene_" + col + "_video_" + p + ".gif",
  		"video": col + "_probably_" + speaker_condition,
  		"modal": "probably",
  		"color": col,
  		"percentage_blue": p
  	}
  	prob_trials.push(trial);
  }	


  // 4 critical trials with orange and blue 100%
  for (var i = 0; i < 5; i++) {
  	var t_idx = prob_trials.length;
  	var col = _.sample(colors);
  	var p = col == "orange" ? "0" : "100";
  	var trial = {
  		"catch_trial": (exp_catch_trial_idxs.indexOf(t_idx) > -1) ? 1 : 0,
  		"image": "scene_" + col + "_video_" + p + ".gif",
  		"video": col + "_bare_" + speaker_condition,
  		"modal": "bare",
  		"color": col,
  		"percentage_blue": p
  	}
  	prob_trials.push(trial);
  }

  // 6 critical trials with orange and blue 75%
  for (var i = 0; i < 5; i++) {
  	var t_idx = prob_trials.length;
  	var col = _.sample(colors);
  	var p = col == "orange" ? "75" : "25";
  	var trial = {
  		"catch_trial": (exp_catch_trial_idxs.indexOf(t_idx) > -1) ? 1 : 0,
  		"image": "scene_" + col + "_video_" + p + ".gif",
  		"video": col + "_might_" + speaker_condition,
  		"modal": "might",
  		"color": col,
  		"percentage_blue": p
  	}
  	prob_trials.push(trial);
  }	



  /////// might biased

  // 10 critical trials with orange and blue 60%
  for (var i = 0; i < 10; i++) {
  	var t_idx = might_trials.length;
  	var col = _.sample(colors);
  	var p = col == "orange" ? "40" : "60";
  	var trial = {
  		"catch_trial": (exp_catch_trial_idxs.indexOf(t_idx) > -1) ? 1 : 0,
  		"image": "scene_" + col + "_video_" + p + ".gif",
  		"video": col + "_might_" + speaker_condition,
  		"modal": "might",
  		"color": col,
  		"percentage_blue": p
  	}
  	might_trials.push(trial);
  }	


  // 4 critical trials with orange and blue 100%
  for (var i = 0; i < 5; i++) {
  	var t_idx = might_trials.length;
  	var col = _.sample(colors);
  	var p = col == "orange" ? "0" : "100";
  	var trial = {
  		"catch_trial": (exp_catch_trial_idxs.indexOf(t_idx) > -1) ? 1 : 0,
  		"image": "scene_" + col + "_video_" + p + ".gif",
  		"video": col + "_bare_" + speaker_condition,
  		"modal": "bare",
  		"color": col,
  		"percentage_blue": p
  	}
  	might_trials.push(trial);
  }

  // 6 critical trials with orange and blue 90%
  for (var i = 0; i < 5; i++) {
  	var t_idx = might_trials.length;
  	var col = _.sample(colors);
  	var p = col == "orange" ? "10" : "90";
  	var trial = {
  		"catch_trial": (exp_catch_trial_idxs.indexOf(t_idx) > -1) ? 1 : 0,
  		"image": "scene_" + col + "_video_" + p + ".gif",
  		"video": col + "_probably_" + speaker_condition,
  		"modal": "probably",
  		"color": col,
  		"percentage_blue": p
  	}
  	might_trials.push(trial);
  }	
}

build_exposure_trials(exposure_trials_1, exposure_trials_2, "f");
build_exposure_trials(exposure_trials_2, exposure_trials_1, "m");


exposure_trials = {
	"confident_m": exposure_trials_1,
	"confident_f": exposure_trials_2
};

