

var MAX_COINS = 10;

var REPETITIONS = 1;

var first_catch_trial = true;

function build_trials() {
	var trials = [];	
	for (var i = 0; i < REPETITIONS; i++) {
    for (var j = 0; j < modals.length; j++) {
			for (var k = 0; k < colors.length; k++) {
				trials.push({
					"modal": modals[j],
					"color": colors[k],
          "speaker_condition": SPEAKER_CONDITION,
					"audio": "./stimuli/" + colors[k] + "_" + modals[j] + "_" + SPEAKER_CONDITION,
					"image": "./stimuli/scene_empty_" + colors[k] + "_hidden_video.png"
				});
			}
		}
	}
	return trials;
}

function tallyCoins() {
  var total = $(".coin").map(function() {
    return parseInt($(this).attr("src").split("coins_")[1].replace(".png", ""));
  })
  .get()
  .reduce(function(acc, val) {
    return acc + val;
  });
  if (total == MAX_COINS) {
    $(".control").each(function() {
      if ($(this).val() != "+") return;
      $(this).attr("disabled", "disabled");
    });
    $("#post-next-button").attr("disabled", null);
  } else {
    $(".control").each(function() {
      if ($(this).val() != "+") return;
      $(this).attr("disabled", null);
    });
    $("#post-next-button").attr("disabled", "disabled");
  }
  $("#available-coins").attr("src", "./stimuli/coins_" + (MAX_COINS-total) + ".png");
};




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
    
		$("#post-video-source-mp4").attr("src", stim.audio + ".mp4");
		$("#post-video-source-ogg").attr("src", stim.audio + ".ogg");
		$("#post-video").trigger("load");
		$("#post-canvas").css({
			"background-image": "url('" + stim.image +  "')"
		});
    $(".coin").attr("src", "./stimuli/coins_0.png");
    $("#remaining-coins").attr("src", "./stimuli/coins_" + MAX_COINS + ".png");
    $(".control").each(function(){
      if ($(this).val() != "+")  
        $(this).attr("disabled", "disabled");
    });
    
    tallyCoins();


    for (var i = 1; i < 10; i++) {
      utils.make_slider("#slider_" + i, function() {}, "vertical");
    }
    
			$("#post_trial").fadeIn(700, function() {
				window.setTimeout(function(){
					$("#post-video").trigger("play");
				}, 400);
			});
  };
	
	
	var button_trial = function(response) {
    this.response = response;
  	this.log_responses();
		var t = this;
		$("#post_trial").fadeOut(300, function() {
			window.setTimeout(function() {
				_stream.apply(t);
			}, 700);
		});
    
    
	}
  
  var get_rating = function(i) {
    return parseInt($("#coins-" + i).attr("src").split("coins_")[1].replace(".png", ""));
  }
	
	var log_response_trial = function() {		
    for (var i = 1; i < 10; i++) {
      exp.data_trials.push({
        "modal": this.stim.modal,
        "color": this.stim.color,
        "percentage_blue": percentages[i-1],
        "rating": get_rating(i)
      });
    }
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
			
			$("#exp_trial").fadeIn(700, function() {
				window.setTimeout(function(){
					$("#exp-video").trigger("play");
				}, 50);
			});
			
			
    },
    button : function(response) {
			this.response = response;
			
			if (this.stim.catch_trial && this.step == 0) {
				this.step = 1;
				this.stim.correct_answer = _.sample([1, 2]);
        var other_perc_idx = this.stim.percentage_blue > 50 ? percentages.indexOf(parseInt(this.stim.percentage_blue)) - 4 : percentages.indexOf(parseInt(this.stim.percentage_blue)) + 4;
        other_perc_idx = Math.max(Math.min(other_perc_idx, percentages.length - 1), 0);
        var other_perc = percentages[other_perc_idx];
				$("#exp_trial-content").hide();
        if (this.stim.correct_answer == 1) {
          $("#catch-gb-1").attr("src", "./stimuli/gumball_" + this.stim.percentage_blue + ".gif");
          $("#catch-gb-2").attr("src", "./stimuli/gumball_" + other_perc + ".gif");
          
        } else {
          $("#catch-gb-2").attr("src", "./stimuli/gumball_" + this.stim.percentage_blue + ".gif");
          $("#catch-gb-1").attr("src", "./stimuli/gumball_" + other_perc + ".gif");
          
        }
				$("#exp_trial-catch").show();
			} else if ( ! this.stim.catch_trial || this.step == 1) {
				this.step = 0;
			
			
		  	var t = this;
				this.stim.catch_trial =  this.stim.catch_trial ? 1 : 0;
				
				var catch_trial_correct = -1;
		  	
				if (this.stim.catch_trial) {
					catch_trial_correct =  (this.response === this.stim.correct_answer ? 1: 0);
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
  
  slides.auth = slide({
    "name": "auth"
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
  exp.structure=["i0", "auth", "video_test", "instructions", "exp_trial", "test_instructions", "post_trial", 'subj_info', 'thanks'];
  //exp.structure=["i0", "video_test", "instructions", "test_instructions", "post_trial", 'subj_info', 'thanks'];

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
  
  for (var i = 0; i < percentages.length; i++) {
    imgs.push("./stimuli/gumball_" + percentages[i] + ".gif")
  }
	

	
	$("#exp-video").bind("ended", function() {
		$("#exp-button").attr("disabled", null);
		
	});
  
 
  
  $(".control").click(function(evt) {
    var machine = $(this).data("machine"); 
    var coins = $("#coins-" + machine).attr("src").split("coins_")[1].replace(".png", "");
    coins = parseInt(coins) + (($(this).val() == "+") ? 1 : -1); 
    $("#coins-" + machine).attr("src", "./stimuli/coins_" + coins + ".png"); 
    if (coins == 0) {
      $(this).attr("disabled", "disabled");
    } else if ($(this).val() == "+") {
      $(this).prev().attr("disabled", null);
    }
    tallyCoins();
  });
  tallyCoins();
  
  
  $(".control").each(function() {
    if ($(this).val() != "+") {
      $(this).attr("disabled", "disabled");
    }
  });
  
  
  $(".placeholder").each(function() {
    var key = $(this).text();
    $(this).text(TEMPLATE_DICT[key]);
  });
  
  $("#test_player-mp4").attr("src", "./stimuli/blue_bare_" + SPEAKER_CONDITION + ".mp4")
  $("#test_player-ogg").attr("src", "./stimuli/blue_bare_" + SPEAKER_CONDITION + ".ogv")
	$("#test_player").trigger("load");
	
  preload(imgs);
	
}

function completedCaptcha(resp) {
     $.ajax({
    type: "POST",
    url: "https://stanford.edu/~sebschu/cgi-bin/verify.php",
    data : {"captcha" : resp},
    success: function(data) {
      if (data != "failure") {
        exp[data]();
      } else {
        $(".loading").hide()
        $(".captcha_error").show();
      }
      },
    error: function() { 
      console.log("Error: form not sent"); 
      },  
    }); 

}
