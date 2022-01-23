$(document).ready(function () {
    VoiceCircle = new ProgressBar.Circle("#VoiceCircle", {
        color: "#FFFFFF",
        trailColor: "#737373",
        strokeWidth: 12,
        trailWidth: 12,
        duration: 250,
        easing: "easeInOut",
    });
    VoiceCircle.animate(0.33);

    HealthCircle = new ProgressBar.Circle("#HealthCircle", {
      color: "#00b65b",
      trailColor: "#013214",
      strokeWidth: 12,
      trailWidth: 12,
      duration: 250,
      easing: "easeInOut",
    });
  
    ArmourCircle = new ProgressBar.Circle("#ArmourCircle", {
      color: "#00BFFF",
      trailColor: "#236B8E",
      strokeWidth: 12,
      trailWidth: 12,
      duration: 250,
      easing: "easeInOut",
    });

    HungerCircle = new ProgressBar.Circle("#HungerCircle", {
        color: "#ffa43b",
        trailColor: "#a5743c",
        strokeWidth: 12,
        trailWidth: 12,
        duration: 250,
        easing: "easeInOut",
    });

    ThirstCircle = new ProgressBar.Circle("#ThirstCircle", {
      color: "#008cff",
      trailColor: "#00559b",
      strokeWidth: 12,
      trailWidth: 12,
      duration: 250,
      easing: "easeInOut",
    });
  
    StaminaCircle = new ProgressBar.Circle("#StaminaCircle", {
      color: "#FFFF00",
      trailColor: "#9B870C",
      strokeWidth: 12,
      trailWidth: 12,
      duration: 250,
      easing: "easeInOut",
    });

    OxygenCircle = new ProgressBar.Circle("#OxygenCircle", {
        color: "#008cff",
        trailColor: "#00559b",
        strokeWidth: 12,
        trailWidth: 12,
        duration: 250,
        easing: "easeInOut",
    });

    // FuelCircle = new ProgressBar.Circle("#FuelCircle", {
    //     color: "#F08038",
    //     trailColor: "#8F4C21",
    //     strokeWidth: 12,
    //     trailWidth: 12,
    //     duration: 250,
    //     easing: "easeInOut",
    // });

    // SpeedCircle = new ProgressBar.Circle("#SpeedCircle", {
    //     color: "#FFFFFF",
    //     trailColor: "#11151862",
    //     strokeWidth: 12,
    //     trailWidth: 12,
    //     duration: 250,
    //     easing: "easeInOut",
    // });

    $("body").hide();
});

window.addEventListener("message", function(event){
    let data = event.data
    if (data.action == "update_hud" && $('body').is(":visible")) {
        HealthCircle.animate(data.hp / 100);
        if (data.armour == 0) {
            $("#ArmourCircle").hide();
        } else {
            $("#ArmourCircle").show();
            ArmourCircle.animate(data.armour / 100);
        }
        if (data.oxygen == 100) {
            $("#OxygenCircle").hide();
        } else {
            $("#OxygenCircle").show();
            OxygenCircle.animate(data.oxygen / 100);
        }
        if (data.stamina == 100) {
            $("#StaminaCircle").hide();
        } else {
            $("#StaminaCircle").show();
            StaminaCircle.animate(data.stamina / 100);
        }
        HungerCircle.animate(data.hunger / 100);
        ThirstCircle.animate(data.thirst / 100);

        if (data.talking) {
            VoiceCircle.path.setAttribute("stroke", "#FFFFFF");
        } else {
            VoiceCircle.path.setAttribute("stroke", "#A9A9A9");
        }
    } else if (data.action == "hud_pos") {
        $("#container").css("left", data.pos);
        $("#RadioUsers").css("right", data.pos);
    } else if (data.action == "voice_level") {
        VoiceCircle.animate(data.voicelevel / 100);
    } else if (data.action == "toggle_hud") {
        if (data.enable){
            $("body").fadeIn();
        } else if (data.enable == false) {
            $("body").hide();
        }  else {
            $("body").fadeToggle();
        }
    }
    
    if (data.action == "update_radio") {
        $("#RadioUsers").html(data.players);
    }
    // if (data.action == "update_vehiclehud" && $('body').is(":visible")) {
    //     // $("#SpeedIndicator").animate({width: data.speed / 1.75 + '%'});
    //     if (data.speed == "") {
    //         $("#SpeedCircle").fadeOut();
    //     } else {
    //         $("#SpeedCircle").fadeIn();
    //         SpeedCircle.animate((data.speed / 1.75) / 100);
    //         SpeedCircle.setText(data.speed);
    //         SpeedCircle.text.style.fontSize = '1.75vh';
    //     }

    //     if (!data.seatbelt) {
    //         SpeedCircle.path.setAttribute("stroke", "#FF0000");
    //     } else {
    //         SpeedCircle.path.setAttribute("stroke", "#FFFFFF");
    //     }
    // }  

    // if (data.action == "vehicle_hud") {
    //     $("#vehContainer").fadeToggle();
    // }

    // if (data.action == "show_ui") {
    //     if (data.enable) { 
    //         if (data.type == "ui") { $("body").show(); }
    //         if (data.type == "voice") { $("#voicebox").show(); }
    //     } else {
    //         if (data.type == "ui") { $("body").hide(); }
    //         if (data.type == "voice") { $("#voicebox").hide(); }
    //     }
    // }
    // console.log("test")
})