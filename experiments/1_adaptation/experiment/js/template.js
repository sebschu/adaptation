


var REPETITIONS = 2;

var reverse_sent_order = _.sample([true, false]);

var post_trial_idxs = _.range(REPETITIONS * percentages.length * colors.length);

var post_catch_trial_idxs = _.sample(post_trial_idxs, 9);




function build_trials() {
	var trials = [];
	
	var cond = conditions[MODAL_CONDITION];
	
	for (var i = 0; i < REPETITIONS; i++) {
		for (var j = 0; j < percentages.length; j++) {
			for (var k = 0; k < colors.length; k++) {
				var t_idx = trials.length;
				trials.push({
					"catch_trial": (post_catch_trial_idxs.indexOf(t_idx) > -1),
					"pair": cond["pair"].join("-"),
					"sentences": reverse_sent_order ? [cond["sentences"][colors[k]][1], cond["sentences"][colors[k]][0]] : cond["sentences"][colors[k]],
					"color": colors[k],
					"percentage_blue": percentages[j],
					"image": "./stimuli/scene_" + colors[k] + "_video_" + percentages[j] + ".gif",
					"reverse_sent_order": reverse_sent_order ? 1 : 0
				});
			}
		}
	}
	return trials;
}





function make_slides(f) {
  var   slides = {};

  slides.i0 = slide({
     name : "i0",
     start: function() {
      exp.startT = Date.now();
     }
  });
	
	

  slides.instructions = slide({
    name : "instructions",
		start: function() {
			$("#instructions-part2").hide();
			$("#instructions-part3").hide();
			this.step = 1;
		},
    button : function() {
			if (this.step == 1) {
				$("#instructions-part1").hide();
				$("#instructions-part2").show();
				this.step = 2;
			} else  if (this.step == 3){
				$("#instructions-part3").hide();
				$("#instructions-part1").show();
				this.step = 1;
			} else {
				if ($("input[name=checkquestion]:checked").val() !== "no") {
					$("#instructions-part2").hide(); 
					$("#instructions-part3").show();
					this.step = 3;
					exp.misread_instructions = exp.misread_instructions === undefined ? 1 : exp.misread_instructions;
				} else {
					exp.misread_instructions = exp.misread_instructions === undefined ? 0 : exp.misread_instructions;;
		      exp.go(); //use exp.go() if and only if there is no "present" data.
				}
				
			}
			
			
    }
  });

  slides.test_instructions = slide({
    name : "test_instructions",
    button : function() {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });
	
	slides.video_test = slide({
		name: "video_test",
		start: function() {
			$("#video_test-2").hide();
			window.setTimeout(function() {
				$("#test_player").trigger("play");
			}, 400);
			
			$("input[name=videoquestion]").click(function() {
				$("#video_test-button").attr("disabled", null);
			})
		},
		button: function() {
			if ($("input[name=videoquestion]:checked").val() !== "4") {
				$("#video_test-1").hide();
				$("#video_test-2").show();
				
				
			} else {
				exp.go();
			}
		}
	});

  var present_handle_trial = function(stim) {
		
		this.step = 0;
		
		$(".err").hide();
		$("#post_trial-catch").hide();
		$("#post_trial-content").show();
		this.stim = stim;
		//$(".display_condition").html(stim.prompt);
    
		$("#post-canvas").css("background", "url('" + stim.image + "')");
		$("#sent_1").text(stim["sentences"][0][1]);
		$("#sent_2").text(stim["sentences"][1][1]);
		
		if (this.stim.catch_trial) {
			this.stim.show_cross = _.sample([true, false]);
			if (this.stim.show_cross) {
				$("#post-attention-cross").show();
				var pos = _.sample(attention_check_positions);
				$("#post-attention-cross").css(pos);
			} else {
				$("#post-attention-cross").hide();
			}
		} else {
			$("#post-attention-cross").hide();
		}
		
		var callback = function () {
		
			var total = $("#slider_1").slider("option", "value") + $("#slider_2").slider("option", "value") + $("#slider_3").slider("option", "value");
		
		
			if (total > 1.0) {
				var other_total = total - $(this).slider("option", "value");
				$(this).slider("option", "value", 1 - other_total);
			}
		
			var perc = Math.round($(this).slider("option", "value") * 100);
			$("#" + $(this).attr("id") + "_val").val(perc);
		
		}
		utils.make_slider("#slider_1", callback);			
		utils.make_slider("#slider_2", callback);
		utils.make_slider("#slider_3", callback);
		
		$("#post_trial").fadeIn(700);
  };
	
	
	var button_trial = function(response) {
    this.response = response;
		
		var total = $("#slider_1").slider("option", "value") + $("#slider_2").slider("option", "value") + $("#slider_3").slider("option", "value");
		
		if (total < .99) {
      $(".err").show();
		} else {
			
			if (this.stim.catch_trial && this.step == 0) {
				this.step = 1;
				$("#post_trial-content").hide();
				$("#post_trial-catch").show();
			} else if ( ! this.stim.catch_trial || this.step == 1) {
				this.step = 0;
	    	this.log_responses();
				var t = this;
				$("#post_trial").fadeOut(300, function() {
					window.setTimeout(function() {
						_stream.apply(t);
					}, 700);
				});
			
			}
		}
	}
	
	var log_response_trial = function() {
		var sent1 = this.stim.reverse_sent_order == 1 ? this.stim.sentences[1] : this.stim.sentences[0];
		var sent2 = this.stim.reverse_sent_order == 1 ? this.stim.sentences[0] : this.stim.sentences[1];
		
		var catch_trial_correct = -1;
		
		if (this.stim.catch_trial) {
			catch_trial_correct = this.response === this.stim.show_cross ? 1: 0;
		}
		
    exp.data_trials.push({
      "pair" : this.stim.pair,
      "reverse_sent_order" : this.stim.reverse_sent_order,
      "sentence1": sent1[1],
      "sentence2": sent2[1],
      "modal1" : sent1[0],
      "modal2" : sent2[0],
			"rating1" : this.stim.reverse_sent_order == 1 ? $("#slider_2").slider("option", "value") : $("#slider_1").slider("option", "value"),
			"rating2" : this.stim.reverse_sent_order == 1 ? $("#slider_1").slider("option", "value") : $("#slider_2").slider("option", "value"),
			"rating_other" : $("#slider_3").slider("option", "value"),
			"percentage_blue": this.stim.percentage_blue,
			"color": this.stim.color,
			"post_exposure": exp.post_exposure ? 1 : 0,
			"catch_trial": this.stim.catch_trial ? 1 : 0,
			"catch_trial_answer_correct": catch_trial_correct
    });
	}

  slides.pre_trial = slide({
    name: "pre_trial",
    present: exp.pre_trials,
    present_handle: present_handle_trial,
    button : button_trial,
    log_responses : log_response_trial
  });
	
  slides.post_trial = slide({
    name: "post_trial",
    present: exp.post_trials,
    present_handle: present_handle_trial,
    button : button_trial,
    log_responses : log_response_trial
  });
	
  slides.exp_trial = slide({
    name: "exp_trial",
    present: exp.exp_trials,
    present_handle: function(stim) {
			
			this.step = 0;
		
			$("#exp_trial-catch").hide();
			$("#exp_trial-content").show();
			
			this.stim = stim;
			$("#exp-button").attr("disabled", "disabled");
			$("#exp-video-source-mp4").attr("src", "./stimuli/" + stim.video + ".mp4");
			$("#exp-video-source-ogg").attr("src", "./stimuli/" + stim.video + ".ogg");
			$("#exp-video").trigger("load");
			$("#exp-canvas").css({
				"background-image": "url('" + "./stimuli/" + stim.image +  "')"
			});
			
			if (stim.catch_trial) {
				this.stim.show_cross = _.sample([true, false]);
				if (this.stim.show_cross) {
					$("#exp-attention-cross").show();
					var pos = _.sample(attention_check_positions);
					$("#exp-attention-cross").css(pos);
				} else {
					$("#exp-attention-cross").hide();
				}
			} else {
				$("#exp-attention-cross").hide();
			}
			
			$("#exp_trial").fadeIn(700, function() {
				window.setTimeout(function(){
					$("#exp-video").trigger("play");
				}, 400);
			});
			
			
    },
    button : function(response) {
			this.response = response;
			
			if (this.stim.catch_trial && this.step == 0) {
				this.step = 1;
				$("#exp_trial-content").hide();
				$("#exp_trial-catch").show();
			} else if ( ! this.stim.catch_trial || this.step == 1) {
				this.step = 0;
			
			
		  	var t = this;
				this.stim.catch_trial =  this.stim.catch_trial ? 1 : 0;
				
				var catch_trial_correct = -1;
		  	
				if (this.stim.catch_trial) {
					catch_trial_correct = this.response === this.stim.show_cross ? 1: 0;
				}
				
				this.stim.catch_trial_answer_correct =  catch_trial_correct;
				
				
				exp.data_exp_trials.push(this.stim);
				$("#exp_trial").fadeOut(300, function() {
					window.setTimeout(function() {
						_stream.apply(t);
					}, 700);
				});
			}
    }
	
	  });
	





  slides.subj_info =  slide({
    name : "subj_info",
    submit : function(e){
      //if (e.preventDefault) e.preventDefault(); // I don't know what this means.
      exp.subj_data = {
        language : $("#language").val(),
        other_languages : $("#other-language").val(),
        asses : $('input[name="assess"]:checked').val(),
        comments : $("#comments").val(),
        problems: $("#problems").val(),
        fairprice: $("#fairprice").val()
      };
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.thanks = slide({
    name : "thanks",
    start : function() {
      exp.data= {
          "trials" : exp.data_trials,
				  "exp_trials": exp.data_exp_trials,
          "catch_trials" : exp.catch_trials,
          "system" : exp.system,
          "condition" : exp.condition,
				  "misread_instructions": exp.misread_instructions,
          "subject_information" : exp.subj_data,
          "time_in_minutes" : (Date.now() - exp.startT)/60000
      };
      setTimeout(function() {turk.submit(exp.data);}, 1000);
    }
  });

  return slides;
}

/// init ///
function init() {
	exp.post_exposure = true;
  exp.condition = CONDITION;
  exp.exp_trials = _.shuffle(exposure_trials[CONDITION]); 
	exp.post_trials = _.shuffle(build_trials());
  exp.catch_trials = [];
  exp.system = {
      Browser : BrowserDetect.browser,
      OS : BrowserDetect.OS,
      screenH: screen.height,
      screenUH: exp.height,
      screenW: screen.width,
      screenUW: exp.width
    };
  //blocks of the experiment:
  exp.structure=["i0", "video_test", "instructions", "exp_trial", "test_instructions", "post_trial", 'subj_info', 'thanks'];

  exp.data_trials = [];
	exp.data_exp_trials = [];
  //make corresponding slides:
  exp.slides = make_slides(exp);

  exp.nQs = utils.get_exp_length(); //this does not work if there are stacks of stims (but does work for an experiment with this structure)
                    //relies on structure and slides being defined

  $('.slide').hide(); //hide everything

  //make sure turkers have accepted HIT (or you're not in mturk)
  $("#start_button").click(function() {
    if (turk.previewMode) {
      $("#mustaccept").show();
    } else {
      $("#start_button").click(function() {$("#mustaccept").show();});
      exp.go();
    }
  });

 


  exp.go(); //show first slide
	
	imgs = [];
	
	for (var i = 0; i < exp.post_trials.length; i++) {
		imgs.push(exp.post_trials[i].image);
	}
	
	$("#exp-video").bind("ended", function() {
		$("#exp-button").attr("disabled", null);
		
	});
	
	preload(imgs);
	
}
