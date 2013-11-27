/*
******************************************
HomeLESS - Hit Analyzer
Home Laser Shooting Simulator - Hit Analyzer
version 1.1b
by Laabicz
laabicz@gmail.com

www.homeless-eng.webnode.com

last rev. 27.11.2013  (dd.mm.yyyy)
******************************************

This HomeLESS_Hit_Analyzer.pde is part of HomeLESS Hit Analyzer.

HomeLESS Hit Analyzer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or any later version.

HomeLESS: Hit Analyzer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with <insert software name>.  If not, see <http://www.gnu.org/licenses/>.
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
GImageButton btnScrollDown, btnScrollUp, btnMinus,btnPlus, btnSensitivity_up, btnSensitivity_down;
GButton btnNextTarget, btnPreviousTarget ;
GTextField txtCaliber, txtShootLog, txtDelay, txtShooting_Time , txtDuration, txtTarget_number, txtShootlog_filename;
GWindow[] windowTargetsList;
GTimer tmrMilisTimer, tmrSecondsTimer_Shooting_Countdown, tmrSecondsTimer_Shooting_Prepare;
GCombo cboTarget_selection;



void setup()
{
  check_basic_files();
  load_ha_ini();
  load_lang_pack();
  create_window();
  load_ballistics_data();
  //load_target_file();
  //set_selected_target_name(target_number);
  load_target_file();
  

  //G4P.setMouseOverEnabled(true);
  //G4P.cursor(CROSS);
  G4P.setColorScheme(this, GCScheme.GREY_SCHEME);
  G4P.setFont(this, "Verdana", 16);
  
  //Optionbutton
  //draw_webcam_option();
  //create_targets_list_button();
  //create_target_select(); //button
  create_correction_buttons();
  create_sensitivity_buttons();
  load_target_list_combo();  //for combo
  create_target_selection_combo(); //combo
  //create_sound_option();
  create_shooting_conditions();
  create_shooting_style_option();
  create_button_save_changes();
  create_button_Lets_Fire();
  create_button_Reset_Values();
  
  // Interfaces
  create_ShootLog_interface();
 
  // About
  create_about_text();
  
  //NameOfTimer(this,this, called function, period of calling)
  create_timers();
  
  //testing
  //createWindowTargetsList();
  
  camera_setup();
  video.start();
  if(video.available() == false)
  {
    x_position = 100;
    y_position = 240;
    fill(255, 0, 0, 255);
    textSize(50);
    text("NO VIDEO DATA", x_position, y_position, 600, 300);
  };
  
  noStroke();
  //smooth();
};

void draw()
{
  // To do when video running
  //if (video.available() && (b_Configure || b_Shooting))
  
  
  if (video.available() && (b_Configure || (b_shoot_stop == false)))
  {
    video.read();
    // Draw the webcam video onto the screen
    draw_video();
    draw_last_hit();
    draw_current_target();    
    
    // Draw ghost image to calibrate 
    scale_the_target();
    draw_calibration_ghost_image();
    draw_shooting_prepare_countdown();
    draw_sensitivity();
    
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
  /*else
  {
    x_position = 100;
    y_position = 240;
    fill(backround_color);
    rect(x_position, y_position, 400, 60);
    fill(255, 0, 0, 255);
    textSize(50);
    text("NO VIDEO DATA", x_position, y_position, 600, 300);
  };*/
  
  draw_time();
  draw_stats();
  //combo clearing utility :)
  fill(backround_color);
  rect(video_width + 160, 220, 151, 65);
};

