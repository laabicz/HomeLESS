/*
******************************************
HomeLESS - Hit Analyzer
Home Laser Shooting Simulator - Hit Analyzer
version 1.2b devel
by Laabicz
laabicz@gmail.com

www.homeless-eng.webnode.com

last rev. 2014-11-27  (yyyy-mm-dd)
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
along with HomeLESS Hit Analyzer.  If not, see <http://www.gnu.org/licenses/>.
 */


//import codeanticode.gsvideo.*;  //replace this in ver. 1.3, -replaced in 1.2b :-)
import processing.video.*;
import processing.opengl.*;
import hypermedia.net.*;    // import UDP library
import g4p_controls.*;
import ddf.minim.*;


Minim minim;
AudioSample shot_sample;

//GSCapture video;  //old
Capture video;

//GCheckbox cbxShow_last_hit, cbxDiameter;

GToggleGroup optGroup_shooting_style = new GToggleGroup(); //new
//GOption optTraining, optSport, optCombat, optHunting;  //old
GOption optTraining, optSport;  //new

GImageButton btnCorrection_down, btnCorrection_up, btnCorrection_left, btnCorrection_right , btnCorrection_reset, btnScale_reset; // correction buttons
GImageButton btnLetsFire, btnReset, btnExport, btnGhost_corrections, btnGeneral_settings, btnWeapon_settings, btn_Win_target_settings;
GImageButton btnHit_sight_offset_Y_up, btnHit_sight_offset_X_left, btnHit_sight_offset_Y_down, btnHit_sight_offset_X_right, btnHit_sight_offset_zero, btnSave_gun;
GImageButton btnHit_sight_autocenter, btnScrollDown, btnScrollUp, btnSensitivity_up, btnSensitivity_down;
GButton btnNextTarget, btnPreviousTarget ;
GTextField txtShootLog, txtDelay, txtTarget_number, txtShootlog_filename;







GTimer tmrMilisTimer, tmrSecondsTimer_Shooting_Countdown, tmrSecondsTimer_Shooting_Prepare;

//HIP config
UDP udp;

GDropList dropList_weapon_selection;


void setup()
{
  System.out.println("\nJava Runtime Enviroment is present.\n");
  
  //println("\n\nStarting HomeLESS Hit Analyzer... \n\n"); add this mesage into startup script
  //frameRate(30);
  check_basic_files();
  load_ha_ini();
  
  minim = new Minim(this); //enable sound
  HIP_setup();
  generate_list_of_targets_files();
  generate_list_of_gun_files();

  load_lang_pack();
  create_window();
  //set_selected_target_name(target_number);
  load_target_file();
  load_weapon_file();

  create_button_win_genereal_settings();
  create_button_win_target_settings();
  create_button_win_weapon_settings();
  //create_sound_option();
  create_button_Lets_Fire();
  //create_button_Save_configuration();  //move into general and target settings
  create_button_Reset_Values();
  
  // Interfaces
  //create_ShootLog_interface();
  create_Export_interface();
 
  // About
  create_about_text();
  
  //NameOfTimer(this,this, called function, period of calling)
  create_timers();
  
  camera_setup();
  video.start();
  if(video.available() == false)
  {
    x_position = 100;
    y_position = 240;
    fill(255, 0, 0, 255);
    textSize(50);
    text("NO VIDEO DATA", x_position, y_position, 600, 300);
    //println("\nError: Suitable webcam is not present.\n");
  };
  
  noStroke();  //disable borders
  //smooth();
};


void draw()
{
  system_clock_timer();
  
  
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
    
    if(b_Configure == true)
      {
        draw_hold_last_hit(); //for sight adjustment 
      };
    
    draw_shooting_prepare_countdown();  //timer needed
    draw_sensitivity();
    
    //*** Finding position of the hit ***
    find_position_of_hit();

    //*** Hit analizying ***
    calculate_hit_range();
    //*** Draw a point into video ***
    draw_position_of_hit();
    hit_points_calculation();
    
    stop_analyze_when_hit_detected(); //enable b_hit_detected
    //TODO: mod obracene detekce
    
    // only when hit detected
    stop_analyze_when_hitcount_overflow();
    write_to_shoot_log();
    send_hit_position();
    
    if(b_Hit_detected)
    {
      if(b_sound_enabled)
      {
      play_gunshot_sample();
      }
    };

    b_Hit_detected = false;
    //stop_by_style();
    stop_by_limits();
  }
  
  draw_time();
  draw_stats();
  draw_conditions();
  //background(backround_color);
};

