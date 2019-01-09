
var reverse_sent_order = _.sample([true, false]);

var PROD_REPETITIONS = 2;


function build_prod_trials() {
	var trials = [];
	
	var cond = conditions[MODAL_CONDITION];
	
	for (var i = 0; i < PROD_REPETITIONS; i++) {
		for (var j = 0; j < percentages.length; j++) {
			for (var k = 0; k < colors.length; k++) {
				trials.push({
					"pair": cond["pair"].join("-"),
					"sentences": reverse_sent_order ? [cond["sentences"][colors[k]][1], cond["sentences"][colors[k]][0]] : cond["sentences"][colors[k]],
					"color": colors[k],
					"percentage_blue": percentages[j],
					"image": "./stimuli/scene_" + colors[k] + "_or_video_" + percentages[j] + ".gif",
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
 
  
	
  
  slides.prod_trial = slide({
    name: "prod_trial",
    present: exp.prod_trials,
    present_handle: function(stim) {
      $(".err").hide();
      this.stim = stim;
      //$(".display_condition").html(stim.prompt);
      
  		$("#post-canvas").css("background", "url('" + stim.image + "')");
			$("#sent_1").text(stim["sentences"][0][1]);
			$("#sent_2").text(stim["sentences"][1][1]);
			
			
			var callback = function () {
				
				var total = $("#prod_slider_1").slider("option", "value") + $("#prod_slider_2").slider("option", "value") + $("#prod_slider_3").slider("option", "value");
				
				
				if (total > 1.0) {
					var other_total = total - $(this).slider("option", "value");
					$(this).slider("option", "value", 1 - other_total);
				}
				
				var perc = Math.round($(this).slider("option", "value") * 100);
				$("#" + $(this).attr("id") + "_val").val(perc);
				
			}
			utils.make_slider2("#prod_slider_1", callback);			
			utils.make_slider2("#prod_slider_2", callback);
			utils.make_slider2("#prod_slider_3", callback);
			
			$("#prod_trial").fadeIn(700);
			
			
    //  $(".response-buttons").attr("disabled", "disabled");
      //$("#prompt").hide();
      //$("#audio-player").attr("autoplay", "true");

    },
    button : function(response) {
      this.response = response;
			
			var total = $("#prod_slider_1").slider("option", "value") + $("#prod_slider_2").slider("option", "value") + $("#prod_slider_3").slider("option", "value");
			
			if (total < .99) {
	      $(".err").show();
			} else {
      	this.log_responses();
				var t = this;
				$("#prod_trial").fadeOut(300, function() {
					window.setTimeout(function() {
						_stream.apply(t);
					}, 700);
				});
		}
      
    },

    log_responses : function() {
			var sent1 = this.stim.reverse_sent_order == 1 ? this.stim.sentences[1] : this.stim.sentences[0];
			var sent2 = this.stim.reverse_sent_order == 1 ? this.stim.sentences[0] : this.stim.sentences[1];
      exp.data_prod_trials.push({
        "pair" : this.stim.pair,
        "reverse_sent_order" : this.stim.reverse_sent_order,
        "sentence1": sent1[1],
        "sentence2": sent2[1],
        "modal1" : sent1[0],
        "modal2" : sent2[0],
				"rating1" : this.stim.reverse_sent_order == 1 ? $("#prod_slider_2").slider("option", "value") : $("#prod_slider_1").slider("option", "value"),
				"rating2" : this.stim.reverse_sent_order == 1 ? $("#prod_slider_1").slider("option", "value") : $("#prod_slider_2").slider("option", "value"),
				"rating_other" : $("#prod_slider_3").slider("option", "value"),
				"percentage_blue": this.stim.percentage_blue,
				"color": this.stim.color
      });
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
				  "prod_trials": exp.data_prod_trials,
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
  exp.condition = MODAL_CONDITION;
  exp.prod_trials = _.shuffle(build_prod_trials()); 
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
  exp.structure=["i0", "auth", "instructions", "prod_trial", 'subj_info', 'thanks'];
  //exp.structure=["i0", "video_test", "instructions", "test_instructions", "post_trial", 'subj_info', 'thanks'];

  exp.data_trials = [];
	exp.data_prod_trials = [];
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
  
	for (var i = 0; i < exp.prod_trials.length; i++) {
		imgs.push(exp.prod_trials[i].image);
	}
	

	
	
  
  $(".placeholder").each(function() {
    var key = $(this).text();
    $(this).text(TEMPLATE_DICT[key]);
  });

  $("#speaker-still-img").attr("src", "./stimuli/still_" + SPEAKER_CONDITION + ".jpg")
	
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
