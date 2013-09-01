/*
******************************************
HomeLESS - Hit Analyzer
Home Laser Shooting Simulator - Hit Analyzer
version 1.0a
by Laabicz
laabicz@gmail.com

www.homeless-eng.webnode.com

last rev. 29.08 2013  (dd.mm.yyyy)
******************************************
 */


import codeanticode.gsvideo.*;
import guicomponents.*;
import processing.opengl.*;
import controlP5.*;


ControlP5 controlP5;
MultiList l;


GSCapture video;


GCheckbox cbxSound, cbxShow_last_hit, cbxDiameter;

GOptionGroup optGroup_shooting_style = new GOptionGroup();
GOption optTraining, optSport, optCombat, optHunting;
GButton btnSave, btnNewShot, btnResetValues, btnExport, btnReset, btnLetsFire, btnTargetsList; 
GImageButton btnCorrection_down, btnCorrection_up, btnCorrection_left, btnCorrection_right , btnCorrection_reset, btnScale_reset; // correction buttons
GImageButton btnScrollDown, btnScrollUp, btnMinus,btnPlus;
GButton btnNextTarget, btnPreviousTarget ;
GTextField txtCaliber, txtShootLog, txtDelay, txtShooting_Time , txtDuration, txtTarget_number, txtShootlog_filename;
GWindow[] windowTargetsList;
GTimer tmrMilisTimer, tmrSecondsTimer_Shooting_Countdown, tmrSecondsTimer_Shooting_Prepare;

void setup()
{
  check_basic_files();
  load_ha_ini();
  load_lang_pack();
  create_window();
  load_ballistics_data();
  //load_target_file();
  set_selected_target_name(target_number);
  load_target_file();
  

  //G4P.setMouseOverEnabled(true);
  //G4P.cursor(CROSS);
  G4P.setColorScheme(this, GCScheme.GREY_SCHEME);
  G4P.setFont(this, "Verdana", 16);
  
  //Optionbutton
  //draw_webcam_option();
  
  create_shooting_style_option();
  create_targets_list_button();
  create_target_select();
  //create_sound_option();
  create_caliber_option();
  create_correction_buttons();
  create_button_save_changes();
  
  create_button_Lets_Fire();
  create_button_Reset_Values();
  
  // Interfaces
  create_counters_interface();
  create_ShootLog_interface();
 
  // About
  create_about_text();
  
  //NameOfTimer(this,this, called function, period of calling)
  create_timers();

  // Uses the default video input, see the reference if this causes an error
  //video = new GSCapture(this, 640, 480, "/dev/video1");
  //video = new GSCapture(this, 640, 480, "/dev/video0");
  //windows xp
  video = new GSCapture(this, video_width, video_height);
  
  video.start();  
  noStroke();
  //smooth();
};

void draw()
{
  // To do when video running
  if (video.available() && (b_Configure || b_Shooting))
  {
    video.read();
    // Draw the webcam video onto the screen
    draw_video();
    draw_last_hit();
    draw_current_target();
    draw_time();
    
    
    // Draw ghost image to calibrate 
    //analyze target
    scale_the_target();
    draw_calibration_ghost_image();
    draw_shooting_prepare_countdown();
    //draw_countdown();
    
    
    //*** Finding position of the hit ***
    find_position_of_hit();
    //*** Hit analizing ***
    calculate_hit_range();
    //*** Draw a point into video ***
    draw_position_of_hit();
    hit_points_calculation();
    stop_analyze_when_hit_detected();
    stop_analyze_when_hitcount_overflow();
    write_to_shoot_log();
    stop_by_style();
  }
  draw_stats();
 
};

