import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import codeanticode.gsvideo.*; 
import guicomponents.*; 
import processing.opengl.*; 
import controlP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class HomeLESS_Hit_Analyzer extends PApplet {

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

public void setup()
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

public void draw()
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

public int x_position, y_position, lenght;
public int backround_color = 180;
public int video_width = 640, video_height = 480;
public int x_window_size, y_window_size; 
//language pack
public String s_Filename,s_Correction,s_Caliber,s_Infobox,s_Duration,s_Targets_list,s_New_shoot,s_Target_no,s_Sound,s_SLH,s_Lets_fire,s_Time,s_Reset,s_Export,s_Points,s_Hits,s_Total,s_Target,s_About,s_found_target_files, s_Save, s_Shooting_style, s_Training, s_Sport, s_Combat, s_Hunting, s_Shooter;
public String s_shooting_time, s_shooting_prepare;
String[] images;



public void create_window()
{
  if(video_height == 480) //640*480
   {
    x_window_size = video_width + 330;
    y_window_size = video_height + 160;
   }
  else  // higher resolution
   {
    x_window_size = video_width + 340;
    y_window_size = video_height + 130;
   }
  size(x_window_size, y_window_size);
  background(backround_color);
  frameRate(30);
  float f_video_width = video_width;
  float f_video_height = video_height;
  f_resolution_ratio = (f_video_width / f_video_height);
};


public void create_shooting_style_option()
  {
 

    x_position = video_width + 30;
    y_position = 260;
    fill(0, 0, 0, 255);
    textSize(16);
    
    text(s_Shooting_style, x_position , y_position - 25, 200, 30);
    
    //training - no shootlog
    text(s_Training, x_position +20, y_position, 200, 30);
    optTraining = new GOption(this, "",  x_position, y_position, 120);
    //sport
    text(s_Sport, x_position +20 , y_position + 25, 200, 30);
    optSport = new GOption(this, "",  x_position, y_position + 25, 120);
    //combat
    text(s_Combat, x_position +125 , y_position, 200, 30);
    optCombat = new GOption(this, "", x_position + 100, y_position, 120);
    //hunting
    text(s_Hunting, x_position +125 , y_position + 25, 200, 30);
    optHunting = new GOption(this, "", x_position + 100, y_position + 25, 120);
    optGroup_shooting_style.addOption(optTraining);
    optGroup_shooting_style.addOption(optSport);
    optGroup_shooting_style.addOption(optCombat);
    optGroup_shooting_style.addOption(optHunting);
    if(shooting_style == 1)
    {
      optTraining.setSelected(true);
    }
    if(shooting_style == 2)
    {
      optSport.setSelected(true);
    }
    if(shooting_style == 3)
    {
      optCombat.setSelected(true);
    }
    if(shooting_style == 4)
    {
      optHunting.setSelected(true);
    }

  };


public void create_correction_buttons()
{
  x_position = video_width + 65;
  y_position = 120;
  text(s_Correction, x_position -35 , y_position - 60, 200, 30);
  
  //off over click
  images = new String[]{ "graphics/arrow_up_1.png", "graphics/arrow_up_2.png", "graphics/arrow_up_3.png" };
  btnCorrection_up = new GImageButton(this,"arrow_up",images, x_position, y_position - 30);
  btnCorrection_up.tag = "Correction_up";
  
  images = new String[]{ "graphics/arrow_left_1.png", "graphics/arrow_left_2.png", "graphics/arrow_left_3.png" };
  btnCorrection_left = new GImageButton(this,"arrow_left",images, x_position - 30, y_position);
  btnCorrection_left.tag = "Correction_left";
  
  images = new String[]{ "graphics/arrow_down_1.png", "graphics/arrow_down_2.png", "graphics/arrow_down_3.png" };
  btnCorrection_down = new GImageButton(this,"arrow_down",images, x_position, y_position);
  btnCorrection_down.tag = "Correction_down";
  
  images = new String[]{ "graphics/arrow_right_1.png", "graphics/arrow_right_2.png", "graphics/arrow_right_3.png" };
  btnCorrection_right = new GImageButton(this,"arrow_right",images, x_position + 30 , y_position);
  btnCorrection_right.tag = "Correction_right";
  
  images = new String[]{ "graphics/minus_1.png", "graphics/minus_2.png", "graphics/minus_3.png" };
  btnMinus = new GImageButton(this,"minus",images, x_position - 30 , y_position - 30);
  btnMinus.tag = "Correction_minus";
  
  images = new String[]{ "graphics/plus_1.png", "graphics/plus_2.png", "graphics/plus_3.png" };
  btnPlus = new GImageButton(this,"plus",images, x_position + 30 , y_position - 30);
  btnPlus.tag = "Correction_plus";
  
  images = new String[]{ "graphics/scale_reset_1.png", "graphics/scale_reset_2.png", "graphics/scale_reset_3.png" };
  btnScale_reset = new GImageButton(this,"scale_reset",images, x_position + 60 , y_position - 30);
  btnScale_reset.tag = "Reset_scale";
  
  images = new String[]{ "graphics/correction_reset_1.png", "graphics/correction_reset_2.png", "graphics/correction_reset_3.png" };
  btnCorrection_reset = new GImageButton(this,"correction_reset",images, x_position + 60 , y_position);
  btnCorrection_reset.tag = "Correction_reset"; 
};

public void create_caliber_option()
{
  x_position = video_width + 180;
  y_position = 60;
  fill(0, 0, 0, 255);
  textSize(16);
  text(s_Caliber, x_position, y_position, 200, 30);

  txtCaliber = new GTextField(this, String.valueOf(txt_projectile_diameter), x_position + 80, y_position, 50, 20);
  txtCaliber.addEventHandler(this, "handle_txtCaliber");
};

public void create_counters_interface()
{
  x_position = video_width + 180;
  y_position = 90;
  text(s_Time, x_position, y_position, 200, 30);
  text(s_Duration, x_position, y_position + 30, 200, 30);

  txtShooting_Time = new GTextField(this, String.valueOf(f_shooting_time), x_position + 80 , y_position, 50, 20);
  txtShooting_Time.addEventHandler(this, "handle_txtShooting_Time");
  txtDuration = new GTextField(this, String.valueOf(duration), x_position + 80, y_position + 30, 50, 20);
  txtDuration.addEventHandler(this, "handle_txtDuration");
};



public void create_targets_list_button()
{
  x_position = video_width + 25;
  y_position = 180;
  btnTargetsList = new GButton(this, s_Targets_list, x_position, y_position, 120, 25);
  btnTargetsList.tag = "TargetsList";
};



public void create_target_select()
{
  x_position = video_width + 180;
  y_position = 150;
  fill(0, 0, 0, 255);
  textSize(16);
  text(s_Target_no, x_position , y_position , 130, 30);
  txtTarget_number = new GTextField(this, String.valueOf(target_number), x_position + 100 , y_position, 30, 20);
  txtTarget_number.addEventHandler(this, "handle_txtTarget_number");
};

public void create_button_save_changes()
{
  x_position = video_width + 180;
  y_position = 180;
  fill(0, 0, 0, 255);
  textSize(16);
  btnSave = new GButton(this, s_Save , x_position, y_position, 130, 25);
  btnSave.tag = "Save";
};


public void createWindowTargetsList()
{ 
  x_position = 10;
  y_position = 20;
  windowTargetsList = new GWindow[1];
  windowTargetsList[0] = new GWindow(this, s_Targets_list, x_position, y_position,200,200,false, JAVA2D);
  windowTargetsList[0].setBackground(backround_color +30);
  windowTargetsList[0].addDrawHandler(this, "windowDraw");
  windowTargetsList[0].addMouseHandler(this, "windowMouse");
 // windowDraw();
}


public void create_sound_option()
{
  x_position = video_width + 30;
  y_position = 170;
  fill(0, 0, 0, 255);
  textSize(16);
  cbxSound = new GCheckbox(this,"", x_position, y_position, 15);
  text(s_Sound, x_position + 15 , y_position - 2, 150, 30);
  cbxSound.setBorder(0);
  if(b_sound)
    {
    cbxSound.setSelected(true);
    }
  else
    cbxSound.setSelected(false);
};



public void create_button_Lets_Fire()
{
  x_position = video_width + 30;
  y_position = 320;
  btnLetsFire = new GButton(this, s_Lets_fire , x_position, y_position, 110, 25);
  btnLetsFire.tag = "Let's fire";
};

public void create_button_Reset_Values()
{
  x_position = video_width + 230;
  y_position = 320;
  btnReset = new GButton(this, s_Reset , x_position, y_position, 80, 25);
  btnReset.tag = "Reset";
};


public void create_ShootLog_interface()
{
  x_position = video_width + 30;
  y_position = 380;
  textSize(16);
  text(s_Infobox, x_position , y_position -25, 100, 25);
  txtShootLog = new GTextField(this, "", x_position, y_position, 280, 190, true);
  txtShootLog.addEventHandler(this, "handle_txtShootLog");
  

  
  text(s_Filename, x_position , y_position + 200, 120, 25);
  txtShootlog_filename = new GTextField(this, "default", x_position +90 , y_position +200, 100, 25);
  txtShootlog_filename.addEventHandler(this, "handle_txtShootlog_filename");
  
  btnExport = new GButton(this, s_Export , x_position + 200, y_position +200, 80, 25);
  btnExport.tag = "Export";
  
  
  images = new String[]{ "graphics/scroll_up_1.png", "graphics/scroll_up_2.png", "graphics/scroll_up_3.png" };
  btnScrollUp = new GImageButton(this,"ScrollUp",images, x_position + 256 , y_position);
  btnScrollUp.tag = "ScrollUp";
  
  
  images = new String[]{ "graphics/scroll_down_1.png", "graphics/scroll_down_2.png", "graphics/scroll_down_3.png" };
  btnScrollDown = new GImageButton(this,"scroll_down",images, x_position + 256 , y_position +166);
  btnScrollDown.tag = "ScrollUp";
  
  
  
};


public void draw_current_target()
{
  x_position = video_X_offset;
  y_position = 0;
  fill(backround_color);  
  rect(x_position, y_position, 520, video_Y_offset);
  textSize(40);
  fill(0, 170, 30, 255);
  text(s_Target + target_name, x_position, y_position, 600, 100);
};

public void draw_time()
{
  /*
  f_shooting_time = 1450;
  float f_seconds = f_sooting_time % 60;
  float f_minutes = (f_shooting_time - f_seconds) / 60 ;
  */
  //f_sooting_time / 60
  
  x_position = video_width + 30;
  y_position = 0;
  fill(backround_color);  
  rect(x_position, y_position, 260, video_Y_offset);
  textSize(40);
  fill(0, 170, 30, 255);
  text(s_Time, x_position , y_position , 230, 50);
  fill(255, 0, 0, 255);
  convert_time();
  text(s_shooting_time, x_position + 140 , y_position , 230, 50);
}

public void draw_count()
{
  x_position = 260;
  y_position = 160;
  fill(0, 0, 0, 255);
  //textSize(24);
  textSize(200);
  text("" + count, x_position, y_position, 600, 300);
}

public void draw_stats()
{
  x_position = 10;
  y_position = video_height + 50;
  fill(backround_color);  
  if(video_height == 480)
    {
    rect(x_position, y_position, 640, 100); //640*480
    }
  else
    {
    rect(x_position, y_position, 800, 50);  //800*600
    }
  textSize(40);
  fill(0, 170, 30, 255);
  //text(s_Points, x_position, y_position, 250, 300);
  text(s_Points, x_position, y_position, 250, 300);
  text(s_Hits, x_position + 220, y_position, 250, 300);
  text(s_Total, x_position + 410, y_position, 250, 300);
  fill(255, 0, 0, 255);
  


  if(b_Shooting && b_show_last_hit) // show last hit points
  {
  
  // sign for the last hit
  //fill(0, 0, 180, 255);
  text("" + round(hit_points_last), x_position +155, y_position, 250, 300);
  //ellipse(x_position +145, y_position +30, 10, 10);
  }
  else // show actual hit points
  {
  fill(0, 0, 160, 255); //blue
  text("" + round(hit_points_actual), x_position +155, y_position, 250, 300);
  //ellipse(x_position +145, y_position +30, 10, 10);
  };
  
  fill(255, 0, 0, 255);
  text("" + hit_counter, x_position + 330, y_position, 250, 300);
  text("" + hit_points_sum, x_position +540, y_position, 250, 300);
};

public void create_about_text()
{
  x_position = x_window_size - 320;
  y_position = y_window_size  -25;
  textSize(16);
  text(s_About, x_position , y_position , 350, 50);
};


public void windowDraw(GWinApplet appc)
{
  appc.stroke(255);
  appc.strokeWeight(2);
  appc.noFill();
  appc.fill(0, 0, 0, 255);
  appc.textSize(16);
  appc.text("Quit",23,23, 200, 100);
  text("Quit",23,23, 200, 100);
};


// bolean, initial value
public boolean b_Configure = true, b_Shooting = false, b_Hit_detected = false, b_show_last_hit, b_sound, b_ballistics, b_shortcuts = true, b_shoot_stop = false, b_shooting_prepare = false; // Mode
public boolean b_training_style = false, b_hunting_style = false, b_combat_style = false, b_sport_style = false; //Shooting style
public int shooting_style;

// position of up left corner of video stream
public byte video_X_offset = 10, video_Y_offset = 50;
public int webcam_type, center_video_X, center_video_Y, correction_X, correction_Y, target_diameters_center_X, target_diameters_center_Y;
public int i_delay, i_shooting_prepare;
public float f_delay, f_10delay, dia;
public float f_shooting_time;
public ArrayList shoot_logs = new ArrayList();
public int shoot_log_counter = 0, new_shooting_start_time, duration;
public int count;
public float f_resolution_ratio;


public void create_timers()
{
  tmrMilisTimer = new GTimer(this, this, "MilisTimerFunction", 100);
  tmrSecondsTimer_Shooting_Countdown = new GTimer(this, this, "tmrSecondsTimer_Shooting_Countdown", 1000);
  tmrSecondsTimer_Shooting_Prepare = new GTimer(this, this, "tmrSecondsTimer_Shooting_Prepare", 1000);
  //tmrTimer.start();
  //tmrTimer.stop();
};

public void tmrSecondsTimer_Shooting_Countdown()
{
  f_shooting_time--;
  if(f_shooting_time == 0)
  {
    tmrSecondsTimer_Shooting_Countdown.stop();
  }
  
  //System.out.println("f_shooting_time: " + f_shooting_time);
}

public void tmrSecondsTimer_Shooting_Prepare()
{
  i_shooting_prepare--;
  if(i_shooting_prepare == 0)
  {
    b_Configure = false;
    //cbxConfigure.setSelected(false);
    b_Shooting = true;
    //tmrSecondsTimer_Shooting_Countdown.start();
    
    if(b_hunting_style || b_sport_style)
    {
      tmrSecondsTimer_Shooting_Countdown.start(); 
    }
    
    tmrSecondsTimer_Shooting_Prepare.stop();
    System.out.println("    tmrSecondsTimer_Shooting_Prepare.stop(); "); 

    b_shooting_prepare = false;
    i_shooting_prepare = Integer.valueOf(s_shooting_prepare).intValue();
  } 
}


//
public void MilisTimerFunction() //every 100 ms
{

  new_shooting_start_time--;
  //System.out.println("new_shooting_start_time: " + new_shooting_start_time);
  if((new_shooting_start_time <= 0) && (b_Configure == false) && (b_Shooting == false) && (b_shoot_stop == false))
    {
      b_Shooting = true;
      new_shooting_start_time = i_delay;
      
      if(b_hunting_style || b_sport_style)
      {
        new_shooting_start_time = 1; // set to something beteween 1 and 10
      }
      
     // System.out.println("new_shooting ready");
      tmrMilisTimer.stop();
    };
}



public void convert_time()
{
 //System.out.println("f_shooting_time: " + f_shooting_time);
 float f_seconds = f_shooting_time % 60;
 float f_minutes = (f_shooting_time - f_seconds) / 60 ;
 String s_seconds = String.valueOf(nf((int)f_seconds,2));
 String s_minutes = String.valueOf(nf((int)f_minutes,2));
 //System.out.println("Minutes: " + s_minutes);
 //System.out.println("Seconds: " + s_seconds); 
 s_shooting_time = s_minutes + ":" + s_seconds;
 //System.out.println("Time: " + s_shooting_time); 
}




public void draw_video()
{
  image(video, video_X_offset, video_Y_offset, video_width, video_height);

};



public void draw_calibration_ghost_image()
{
  if (b_Configure)
    {
      fill(255, 255, 0, 100);

      //circle target
      if(target_type == 0)
        {
        //black diameter
        //t_black_center_image_size = round(targets_diameters[number_of_black_diameter] * target_scale);
        ellipse(target_diameters_center_X + video_X_offset + correction_X , target_diameters_center_Y + video_Y_offset + correction_Y, t_black_center_image_size, t_black_center_image_size);
        //white diameter
        //t_white_border_image_size = round(targets_diameters[number_of_biggest_diameter] * target_scale);
        ellipse(target_diameters_center_X + video_X_offset + correction_X , target_diameters_center_Y + video_Y_offset + correction_Y, t_white_border_image_size, t_white_border_image_size);
        };
      
      //square circle target
      if(target_type == 1)
        {
        rect(A1X + video_X_offset + correction_X, A1Y + video_Y_offset + correction_Y, A2X, A2Y);              
        rect(B1X + video_X_offset + correction_X, B1Y + video_Y_offset + correction_Y, B2X, B2Y);
        //t_black_center_image_size = round(targets_diameters[number_of_black_diameter] * target_scale);
        ellipse(target_diameters_center_X + video_X_offset + correction_X , target_diameters_center_Y + video_Y_offset + correction_Y, t_black_center_image_size, t_black_center_image_size);
        };  
    }
};




public void draw_position_of_hit()
{
  dia = projectile_diameter * diameter_scale;
  if((hit_X > 15) && (hit_X < video_width -15))
    {
      if((hit_Y > 0) && (hit_Y < video_height))
      {
        //color of hit
        //fill(255, 0, 0, 255); //red
        fill(0, 0, 160, 255); //blue
        if(projectile_diameter == 0)// for middle evaluation
        {
          rect(hit_X + video_X_offset - 2, hit_Y + video_Y_offset -17, 3, 15); // up
          rect(hit_X + video_X_offset - 2, hit_Y + video_Y_offset +1, 3, 15); // down
          rect(hit_X + video_X_offset - 17, hit_Y + video_Y_offset -2, 15, 3); // left
          rect(hit_X + video_X_offset + 1, hit_Y + video_Y_offset -2, 15, 3); // right
        }
        else
        {// for ambient avaluation
        //dia = projectile_diameter * diameter_scale;
        ellipse(hit_X + video_X_offset, hit_Y + video_Y_offset, dia, dia);
        }
      }
    };
};

public void draw_shooting_prepare_countdown()
{
  if(b_shooting_prepare == true)
  {
      x_position = ((video_width + video_X_offset)/2) - 60;
      y_position = ((video_height + video_Y_offset)/2) -105;
      fill(0, 0, 160, 255); //blue
      textSize(200);
      text(String.valueOf(i_shooting_prepare), x_position, y_position, 600, 300);
  }
};



public void stop_analyze_when_hitcount_overflow()
{
  if((hit_counter == 99) && (b_training_style == false)) //value 99
   {
     b_Shooting = false;
     b_shoot_stop = true;
     x_position = 140;
     y_position = 200;
     fill(255, 0, 0, 255);
     textSize(150);
     text("STOP", x_position, y_position, 600, 300);
   };
};


public void stop_analyze_when_hit_detected()
{
  if(b_Shooting)
    {
      if((hit_X > 15) && (hit_X < 625))
      {
        if((hit_Y > 15) && (hit_Y < 465))
        {
         hit_points_last = hit_points_actual;
         b_Shooting = false;
         hit_counter++;
         b_Hit_detected = true;
         last_hit_Y = hit_Y;
         last_hit_X = hit_X;
         tmrMilisTimer.start();
         
        }
      }
    }

};

public void draw_last_hit()
{
  if(b_show_last_hit && (hit_counter > 0))
    {
      //fill(255, 255, 50, 255); //yellow
      //fill(0, 0, 160, 255); //blue
      fill(255, 0, 0, 255); //red
      if(projectile_diameter == 0)// for middle evaluation
        {
          rect(last_hit_X + video_X_offset - 2, last_hit_Y + video_Y_offset -17, 3, 15); // up
          rect(last_hit_X + video_X_offset - 2, last_hit_Y + video_Y_offset +1, 3, 15); // down
          rect(last_hit_X + video_X_offset - 17, last_hit_Y + video_Y_offset -2, 15, 3); // left
          rect(last_hit_X + video_X_offset + 1, last_hit_Y + video_Y_offset -2, 15, 3); // right
        }
      else
        ellipse(last_hit_X + video_X_offset, last_hit_Y + video_Y_offset, dia, dia);
    };
};

public void write_to_shoot_log()
{
  String current_shoot_log;
  if(b_Hit_detected && (b_training_style == false))
    {
    shoot_log_counter++;
    
    // Add current message
    shoot_logs.add(nf(shoot_log_counter,2) + ": " + "X: " + nf(hit_X,3) + " Y: " + nf(hit_Y,3));
    // nf(variable, number) - formating data
    
    
    
    
    // Join logs messages into one string
    txtShootLog.setText(join((String[])shoot_logs.toArray(new String[shoot_logs.size()]), '\n'));
    
    
    current_shoot_log = String.valueOf(nf(hit_X,3)) + String.valueOf(nf(hit_Y,3));
    //s_shoot_logs[shoot_log_counter] = String.valueOf(nf(hit_X,3)) + String.valueOf(nf(hit_Y,3));
    s_shoot_logs[shoot_log_counter - 1] = current_shoot_log;
    current_shoot_log = "";
    
    b_Hit_detected = false;
  };
  // Scroll down until last event is visible.
  while(txtShootLog.scroll(GTextField.SCROLL_DOWN));
};

public void stop_by_style()
{
  if(b_hunting_style && (f_shooting_time == 0))
  {
      tmrSecondsTimer_Shooting_Countdown.stop();
      x_position = 140;
       y_position = 200;
       fill(255, 0, 0, 255);
       textSize(150);
       text("STOP", x_position, y_position, 600, 300);
      b_shoot_stop = true;
  };
  
  if(b_combat_style)
  {
    if(duration == hit_counter)
     {
       x_position = 140;
       y_position = 200;
       fill(255, 0, 0, 255);
       textSize(150);
       text("STOP", x_position, y_position, 600, 300);
       //b_Shooting = false;
       b_shoot_stop = true;
     }
  };
  
  if(b_sport_style)
  {
   if(duration == hit_counter || (f_shooting_time == 0))
     {
       x_position = 140;
       y_position = 200;
       fill(255, 0, 0, 255);
       textSize(150);
       text("STOP", x_position, y_position, 600, 300);
      // b_Shooting = false;
       b_shoot_stop = true;
       tmrSecondsTimer_Shooting_Countdown.stop();
     }
  };
}


public void handleCheckboxEvents(GCheckbox cbox)
{
  /*
  if(cbox == cbxConfigure)
    {
    b_shortcuts = true;
    if(cbxConfigure.isSelected())
      {
      b_Shooting = false;
      b_Configure = true;
      }
    else
      {
      b_Configure = false;
      b_Shooting = true;
      } 
    }
   */
   
   
   if(cbox == cbxShow_last_hit) 
     {
     if(cbxShow_last_hit.isSelected())
       {
       b_show_last_hit = true;
       System.out.println("b_show_last_hit true " );
       }
     else
       {
       b_show_last_hit = false;
       System.out.println("b_show_last_hit false " );
       } 
     }
}


public void handleOptionEvents(GOption selOpt, GOption delselOpt)
{  
  
  
  if (selOpt == this.optTraining)
  {
    b_training_style = true;
    b_hunting_style = false;
    b_combat_style = false;
    b_sport_style = false;
    shooting_style = 1;
  }
  else if (selOpt == this.optSport)
  {
    b_training_style = false;
    b_hunting_style = false;
    b_combat_style = false;
    b_sport_style = true;
    shooting_style = 2;
    f_10delay = 1;
    new_shooting_start_time = 1;
  } 
  else if (selOpt == this.optCombat)
  {
    b_training_style = false;
    b_hunting_style = false;
    b_combat_style = true;
    b_sport_style = false;
    shooting_style = 3;
  } 
  else //(selOpt == this.optHunting)
  {
    b_training_style = false;
    b_hunting_style = true;
    b_combat_style = false;
    b_sport_style = false;
    shooting_style = 4;
    f_10delay = 1;
    new_shooting_start_time = 1;
  }

}


public void handleButtonEvents(GButton button)
{
   b_shortcuts = true;// to activate key shortcuts
   
   if((button == btnNewShot) && (b_Configure == false) && (b_shoot_stop == false))// && button.eventType == GButton.CLICKED)
   {
     b_Shooting = true;
   };
  
  if((button == btnLetsFire)&& (b_Configure == true))
  {
    if(b_training_style == true)
    {
    b_Configure = false;
    //cbxConfigure.setSelected(false);
    b_Shooting = true;
    }
    
    if(b_training_style == false)
    {
    b_shooting_prepare = true;
    tmrSecondsTimer_Shooting_Prepare.start();
    }
  };
  /*
   if(button == btnResetValues)// && button.eventType == GButton.CLICKED)
   {
      hit_points_actual = 0;
      hit_points_sum = 0;
      hit_counter = 0;
      b_shoot_stop = false;
      
   };
   */
   
   if(button == btnReset)// && button.eventType == GButton.CLICKED)
   {
     for(int i = 0 ; i < shoot_log_counter ; i++ )
     {
     shoot_logs.remove(0);  // this remove last one
     };
     
     txtShootLog.setText("");
     shoot_log_counter = 0;
     //from delete button
     hit_points_actual = 0;
     hit_points_sum = 0;
     hit_counter = 0;
     hit_points_last = 0;
     tmrSecondsTimer_Shooting_Countdown.stop();
     b_shoot_stop = false;
     b_Shooting = false;
     b_Configure = true;
     //cbxConfigure.setSelected(true);

     
     f_shooting_time = Float.parseFloat(txtShooting_Time.getText());
     System.out.println("f_shooting_time: " + f_shooting_time);
   };
   
   if(button == btnTargetsList && b_Configure)
   {
     //createWindowTargetsList();
     System.out.println("Select target: ");
     
     load_target_list();
     /*
     for(target_number = 0; target_number <= 5;  target_number++)
     {
       shoot_logs.add(nf(target_number,2) + " " + targets_names[target_number]);
       txtShootLog.setText(join((String[])shoot_logs.toArray(new String[shoot_logs.size()]), '\n'));
     }

     for(int i = 0 ; i <= target_number ; i++ )
     {
       shoot_logs.remove(0);
     }
      */

   };
   
   if(button == btnSave)// && button.eventType == GButton.CLICKED)
    {
     save_file_ha_ini();
    };



   if(button == btnExport)// && button.eventType == GButton.CLICKED)
    {
     export_file_shoot_log();
    };


}

public void handleImageButtonEvents(GImageButton imagebutton)
{
  b_shortcuts = true;// to activate key shortcuts
  
  if(b_Configure)
  {
    if(imagebutton == btnCorrection_down)// 
     {
       correction_Y++;
     };
     
    if(imagebutton == btnCorrection_left)// 
     {
       correction_X--;
     };
     
    if(imagebutton == btnCorrection_right)// 
     {
       correction_X++;
     };
   
    if(imagebutton == btnCorrection_up)// 
     {
       correction_Y--;
     };
     
     
    if(imagebutton == btnCorrection_reset)// 
     {
       correction_Y = 0;
       correction_X = 0;
     };
     
     if(imagebutton == btnMinus)// 
      {
       target_scale -= 0.01f;
      };
    
    if(imagebutton == btnPlus)// 
     {
       target_scale += 0.01f;
     }; 
     
     
    if(imagebutton == btnScale_reset)// 
     {
       target_scale = 1;
     }; 
     
 }
 
   if(imagebutton == btnScrollUp)// 
     {
     txtShootLog.scroll(GTextField.SCROLL_UP);
     };
   
   if(imagebutton == btnScrollDown)// 
     {
     txtShootLog.scroll(GTextField.SCROLL_DOWN);
     };
}

public void handleTextFieldEvents(GTextField textfield)
{
 //void
};

public void handle_txtCaliber(GTextField textfield)
{
    
  if (textfield.eventType == GTextField.ENTERED)
    {
    txt_projectile_diameter = Float.parseFloat(txtCaliber.getText());
    projectile_diameter = txt_projectile_diameter;

    }
    
  if(textfield.eventType == GTextField.CHANGED)
    {
    b_shortcuts = false;
    }
};


public void handle_txtShooting_Time(GTextField textfield)  //Time
{
    if (textfield.eventType == GTextField.ENTERED)
    {
      f_shooting_time = Float.parseFloat(txtShooting_Time.getText());
      System.out.println("f_shooting_time: " + f_shooting_time);
    }
  
  if(textfield.eventType == GTextField.CHANGED)
    {
    b_shortcuts = false;
   System.out.println("handle_txtShooting_Time b_shortcuts = false;");

    }
};


public void handle_txtDuration(GTextField textfield)
{
  if (textfield.eventType == GTextField.ENTERED)
    {
    duration = Integer.parseInt(txtDuration.getText());
    System.out.println("Duration: " + duration);
    }
  if(textfield.eventType == GTextField.CHANGED)
    {
    b_shortcuts = false;
    }
};

public void handle_txtTarget_number(GTextField textfield)
{

  if (textfield.eventType == GTextField.ENTERED)
    {
    b_shortcuts = false;
    System.out.println("b_shortcuts: " + b_shortcuts);
    target_number = Integer.parseInt(txtTarget_number.getText());
    set_selected_target_name(target_number);
    target_scale = 1; //reset target scale for new target
    load_target_file();
    }
    
  if(textfield.eventType == GTextField.CHANGED)
    {
    b_shortcuts = false;
    }

};


public void handle_txtShootLog(GTextField textfield)
{
  if(textfield.eventType == GTextField.CHANGED)
    {
    b_shortcuts = false;
    }
}

public void handle_txtShootlog_filename(GTextField textfield)
{
  if(textfield.eventType == GTextField.CHANGED)
    {
    b_shortcuts = false;
    }
};

public void keyPressed()
{
  if(b_shortcuts == true)
  {
  
    //see ASCII
    if( key == 32 || key == 110)  // key == spacebar or n
    {
      b_Shooting = true;
      //System.out.println("Spacebar or n pressed");
    };
    
    if( key == 114 )  // key == r
    {
      for(int i = 0 ; i < shoot_log_counter ; i++ )
      {
      shoot_logs.remove(0);  // this remove last one
      };
      txtShootLog.setText("");
      shoot_log_counter = 0;
      hit_points_actual = 0;
      hit_points_sum = 0;
      hit_counter = 0;
      hit_points_actual = 0;
      hit_points_last = 0;
      b_shoot_stop = false;
      //System.out.println("reset key r pressed");
    };
    
    
    if( key == 101)  // key == e
    {
     export_file_shoot_log();
    }
    
    if( key == 115)  // key == s
    {
     //Sound handle
     save_file_ha_ini();
    }
    
    
    if(b_Configure)
    {
      /*** Target correction ***/
      if(key == CODED)
      { 
        if (keyCode == LEFT)
        { 
        correction_X--;  //left
        } 
        
        if (keyCode == DOWN)
        { 
         correction_Y++;  //down 
        } 
        
        if (keyCode == RIGHT)
        { 
        correction_X++;  //right
        } 
        
        if (keyCode == UP)
        { 
        correction_Y--;  //up
        }   
      }
      /*** Target scale ***/  
      if( key == 47)  // key == /
      {
        correction_Y = 0;
        correction_X = 0;
      }
      
      if( key == 43 && b_Configure)  // key == +
      {
        target_scale += 0.01f;
      }
      
      if( key == 45 && b_Configure)  // key == -
      {
        target_scale -= 0.01f;
      }
      
      if( key == 42 && b_Configure)  // key == *
      {
        target_scale = 1;
      }
      
    }
  }// end of if(shortcuts)

};

public int y_projectile_shift; //for basic ballistics
public int real_distance, shooting_distance;
public float real_size, shooting_size;


public void load_ballistics_data()
{
  System.out.println("Ballistic data file loaded \n");
  y_projectile_shift = 0;
};


public String target_name, name_of_target_file;
public int target_number, target_type;
String[] targets_names;
public boolean b_ha_ini_exist = false, b_english_lng_exist = false;
//dafaluts strings
String[] s_default_ha_ini = {"Webcam = 0","Video width = 640","Video height = 480","Sound = 0","Style = 1","SLH = 1","language = english","Caliber = 4.5","Delay = 3","Duration = 5","Target = 1","Scale = 1.00","X correction = 5000","Y correction = 5000", "Time = 120", "Prepare = 5"};
String[] s_ha_ini_clear_contain  = {"Webcam = ","Video width = ","Video height = ","Sound = ","Style = ","SLH = ","language = ","Caliber = ","Delay = ","Duration = ","Target = ","Scale = ","X correction = ","Y correction = ", "Time = ", "Prepare = "};
String[] s_ha_ini_contain  = {"Webcam = ","Video width = ","Video height = ","Sound = ","Style = ","SLH = ","language = ","Caliber = ","Delay = ","Duration = ","Target = ","Scale = ","X correction = ","Y correction = ", "Time = ", "Prepare = "};
String[] s_shoot_logs = new String[100];
//String[] s_ha_ini_contain = new String[14];
String[] s_default_english_lng = {"Filename:","Correction:","Caliber:","Infobox:","Duration:","Targets list","New shoot","Target no.:","Sound","SLH","Let's fire","Time:","Reset","Export","Points:","Hits:","Total:","Target:","HomeLESS - Hit Analyzer version 1.0a","Found target files:","Save changes", "Shooting style:", "Training", "Sport", "Combat", "Hunting", "Shooter:"};
String s_language_file, s_current_language, s_shoot_log_contain ,s_shootlog_full_filename, s_shootlog_filename;



public void check_basic_files()
{
  String path = sketchPath;
  String  file_name;
  ArrayList allFiles = listFilesRecursive(path);
  
  // try to locate basic files: ha.ini, english.lng
  // ha.ini
  File[] files = listFiles(path);
  for (int i = 0; i < files.length; i++)
  {
    File f = files[i];  
    file_name = f.getName();
    is_ha_ini_file(file_name);
  }  
  // ha.ini exist?   
  if(b_ha_ini_exist == false)
    {
    save_file_default_ha_ini();
    };
  
  //english.lng
  for (int i = 0; i < allFiles.size(); i++)
  {
    File f = (File) allFiles.get(i);    
    file_name = f.getName();
    is_english_lng_file(file_name);
  }
 
  if(b_english_lng_exist == false)
    {
    save_file_default_english_lng();
    };
}


public void load_ha_ini()
{
  convert_time();
  
  String[] contain = loadStrings("ha.ini");
  char c_webcam_type, c_sound , c_style, c_SLH;
  String s_video_width, s_video_height, s_laguage_file, s_caliber, s_delay, s_duration, s_target, s_scale, s_correction_X, s_correction_Y;

  //fit
  c_webcam_type = contain[0].charAt(9);
  webcam_type = PApplet.parseInt(c_webcam_type) - 48;
  
  s_video_width = contain[1].substring(14);
  video_width = Integer.valueOf(s_video_width).intValue();
  
  s_video_height = contain[2].substring(15);
  video_height = Integer.valueOf(s_video_height).intValue();
  
  c_sound = contain[3].charAt(8);
  if((PApplet.parseInt(c_sound) - 48) == 1)
    {
     b_sound = true;
    }
  else
    {
     b_sound = false;
    }
  //fit
  c_style = contain[4].charAt(8);
  shooting_style = PApplet.parseInt(c_style) - 48;
  if(shooting_style == 1)
  {
    b_training_style = true;
  }
  if(shooting_style == 2)
  {
    b_sport_style = true;
  }
  if(shooting_style == 3)
  {
    b_combat_style = true;
  }
  if(shooting_style == 4)
  {
    b_hunting_style = true;
  }

  c_SLH = contain[5].charAt(6);
  if((PApplet.parseInt(c_SLH) - 48) == 1)
    {
     b_show_last_hit = true;
    }
  else
    {
     b_show_last_hit = false;
    }

  
  s_current_language = contain[6].substring(11);
  
  s_caliber = contain[7].substring(10);
  txt_projectile_diameter = Float.valueOf(s_caliber).floatValue();
  projectile_diameter = txt_projectile_diameter;

  s_delay = contain[8].substring(8);
  i_delay = Integer.valueOf(s_delay).intValue(); 
  new_shooting_start_time = i_delay;
  
  s_duration = contain[9].substring(11);
  duration = Integer.valueOf(s_duration).intValue();
  
  s_target = contain[10].substring(9);
  target_number = Integer.valueOf(s_target).intValue();
  
  s_scale = contain[11].substring(8);
  target_scale = Float.valueOf(s_scale).floatValue();
  
  s_correction_X = contain[12].substring(15);
  correction_X = Integer.valueOf(s_correction_X).intValue();
  correction_X -= 5000;

  s_correction_Y = contain[13].substring(15);
  correction_Y = Integer.valueOf(s_correction_Y).intValue();
  correction_Y -= 5000;
  
  s_shooting_time = contain[14].substring(7);
  f_shooting_time = Float.valueOf(s_shooting_time).floatValue();
  
  s_shooting_prepare = contain[15].substring(10);
  i_shooting_prepare = Integer.valueOf(s_shooting_prepare).intValue();
  
  System.out.println("Basic file ha.ini file loaded. \n");
};


public void load_lang_pack()
{
  
  String path = sketchPath;
  String  file_name;
  ArrayList allFiles = listFilesRecursive(path);
  s_language_file = "languages/" + s_current_language + ".lng";
  String[] contain = loadStrings(s_language_file);
  //language pack
  s_Filename = contain[0];
  s_Correction = contain[1];
  s_Caliber = contain[2];
  s_Infobox = contain[3];
  s_Duration = contain[4];
  s_Targets_list = contain[5];
  s_New_shoot = contain[6];
  s_Target_no = contain[7];
  s_Sound = contain[8];
  s_SLH = contain[9];
  s_Lets_fire = contain[10];
  s_Time = contain[11];
  s_Reset = contain[12];
  s_Export = contain[13];
  s_Points = contain[14];
  s_Hits = contain[15];
  s_Total = contain[16];
  s_Target = contain[17];
  s_About = contain[18];
  s_found_target_files = contain[19];
  s_Save = contain[20];
  s_Shooting_style = contain[21];
  s_Training = contain[22];
  s_Sport = contain[23];
  s_Combat = contain[24];
  s_Hunting = contain[25];
  s_Shooter = contain[26];
  System.out.println("Basic file lang pack loaded. \n");
};


public void set_selected_target_name(int selected_target)
{

  String path = sketchPath;
  String  file_name;
  ArrayList allFiles = listFilesRecursive(path);


  for (int i = 0; i < allFiles.size(); i++)
  {
    File f = (File) allFiles.get(i);    
    file_name = f.getName();
    if(isTarget(file_name))
    {
      if(getTargetNumber(file_name) == selected_target)
      {
        name_of_target_file = file_name;
      }
    }
  }
};

public void load_target_list()
{

  String path = sketchPath;
  String  file_name;
  ArrayList allFiles = listFilesRecursive(path);
  
  shoot_logs.add(s_found_target_files);
  shoot_log_counter++; 
  for (int i = 0; i < allFiles.size(); i++)
  {
    File f = (File) allFiles.get(i);    
    file_name = f.getName();
    if(isTarget(file_name))
      {
      //getTargetNumber(file_name);
      println(file_name);
      shoot_log_counter++;
      // Add current message
      shoot_logs.add(file_name);
      // nf(variable, number) - formating data
      
      // Join logs messages into one string
      txtShootLog.setText(join((String[])shoot_logs.toArray(new String[shoot_logs.size()]), '\n'));
      }
  }
};
/*
public String get_target_name(int number)
{
  String full_file_target_name ="targets/";
  String name
  full_file_target_name += name_of_target_file;
  String[] contain = loadStrings(full_file_target_name);
  name = contain[0];
  return name
}*/



public void load_target_file()
{
  targets_diameters = new float[40];
  String full_file_target_name ="targets/";
  full_file_target_name += name_of_target_file;
  String[] contain = loadStrings(full_file_target_name);
  target_name = contain[0];
  target_type = Integer.valueOf(contain[1]).intValue();
  last_target_scale = 0;
  
  //circle target
  if(target_type == 0 )
    {
       //circle target i <= 11
       for(int i = 0 ; i<= 11 ; i++ )
        {
         targets_diameters[i] = Float.valueOf(contain[i+1]).floatValue();
         //System.out.println("Diameter no.: " + i + " value: " + targets_diameters[i] + " field number: " + i);
        }
        //number_of_biggest_diameter = Integer.valueOf(contain[13]).intValue();
        set_number_of_biggest_diameter();
        target_diameters_center_X = (video_width / 2) - 1;
        target_diameters_center_Y = (video_height / 2) - 1;
    }
 
 //square circle target
  if(target_type == 1 )
    {
       //circle target i <= 11
       for(int i = 0 ; i<= 11 ; i++ )
        {
         targets_diameters[i] = Float.valueOf(contain[i+1]).floatValue();
         //System.out.println("Diameter no.: " + i + " value: " + targets_diameters[i] + " field number: " + i);
        }
        //number_of_biggest_diameter = Integer.valueOf(contain[13]).intValue();
        set_number_of_biggest_diameter();
        
        A1X = Float.valueOf(contain[13]).floatValue();
        A1Y = 0;
        A2X = Float.valueOf(contain[14]).floatValue();
        A2Y = Float.valueOf(contain[15]).floatValue();
        B1X = 0; 
        B1Y = A2Y;
        B2X = Float.valueOf(contain[16]).floatValue();
        B2Y = Float.valueOf(contain[17]).floatValue();
        CX = Float.valueOf(contain[18]).floatValue();
        CY = Float.valueOf(contain[19]).floatValue();       
    }
 
 //elipse target
  else if(target_type == 2 )
    {
      for(int i = 0 ; i<= 11 ; i++ )
      {
       targets_diameters[i] = Float.valueOf(contain[i+1]).floatValue();
       //System.out.println("Diameter no.: " + i + " value: " + target_diameters[i] + " field number: " + i);
      }
    }
    
  if(target_type == 5 )
    {
       //circle target i <= 11
       for(int i = 0 ; i<= 11 ; i++ )
        {
         targets_diameters[i] = Float.valueOf(contain[i+1]).floatValue();
         //System.out.println("Diameter no.: " + i + " value: " + target_diameters[i] + " field number: " + i);
        }
    }
    
    
  analyze_the_target();

}

public int getTargetNumber(String name)
{
  int number;
  number = Integer.valueOf(name.substring(0,2)).intValue();
  return number;
}


public boolean isTarget(String name)
{
  if(name.endsWith("tgt") == true)
  {
   return true; 
  }
  else
  {
   return false; 
  }
}

public boolean is_ha_ini_file(String name)
{
  //if(name.endsWith("tgt") == true)
  if(name.equals("ha.ini"))
  {
   b_ha_ini_exist = true;
   return true;
  }
  else
  {
   return false; 
  }
}

public boolean is_english_lng_file(String name)
{
  //if(name.endsWith("tgt") == true)
  if(name.equals("english.lng"))
  {
   b_english_lng_exist = true;
   return true;
  }
  else
  {
   return false; 
  }
}

public void save_file_ha_ini()
{
  byte byte_sound, byte_style = 1, byte_SLH = 1;

  //s_ha_ini_contain = s_ha_ini_clear_contain; //init
  /*
  for(int i = 0; i <= 13; i++)
    {
     s_ha_ini_contain[i] = s_ha_ini_clear_contain[i];
     //System.out.println("s_ha_ini_contain[0]: " + s_ha_ini_contain[i]);
    }
    */

  s_ha_ini_contain[0] = "Webcam = ";
  s_ha_ini_contain[1] = "Video width = ";
  s_ha_ini_contain[2] = "Video height = ";
  s_ha_ini_contain[3] = "Sound = ";
  s_ha_ini_contain[4] = "Style = ";
  s_ha_ini_contain[5] = "SLH = ";
  s_ha_ini_contain[6] = "Language = ";
  s_ha_ini_contain[7] = "Caliber = ";
  s_ha_ini_contain[8] = "Delay = ";
  s_ha_ini_contain[9] = "Duration = ";
  s_ha_ini_contain[10] = "Target = ";
  s_ha_ini_contain[11] = "Scale = ";
  s_ha_ini_contain[12] = "X correction = ";
  s_ha_ini_contain[13] = "Y correction = ";
  s_ha_ini_contain[14] = "Time = ";
  s_ha_ini_contain[15] = "Prepare = ";

  //s_ha_ini_contain = s_ha_ini_clear_contain;
  if(b_sound)
    {
     byte_sound = 1;
    }
  else
    {
     byte_sound = 0;
    }
    
  if(b_show_last_hit)
    {
     byte_SLH = 1;
    }
  else
    {
     byte_SLH = 0;
    }   

  s_ha_ini_contain[0] += webcam_type;
  s_ha_ini_contain[1] += video_width;
  s_ha_ini_contain[2] += video_height;
  s_ha_ini_contain[3] += byte_sound;
  s_ha_ini_contain[4] += shooting_style;
  s_ha_ini_contain[5] += byte_SLH;
  s_ha_ini_contain[6] += s_current_language;
  s_ha_ini_contain[7] += projectile_diameter;
  s_ha_ini_contain[8] += i_delay;
  s_ha_ini_contain[9] += duration;
  s_ha_ini_contain[10] += target_number;
  s_ha_ini_contain[11] += target_scale;
  s_ha_ini_contain[12] += (correction_X + 5000);
  s_ha_ini_contain[13] += (correction_Y + 5000);
  s_ha_ini_contain[14] += f_shooting_time;
  s_ha_ini_contain[15] += i_shooting_prepare;
  saveStrings("ha.ini", s_ha_ini_contain);
  System.out.println("Changes in configuration has been saved into ha.ini file.");
  System.out.println("f_delay: " + f_delay);

};




public void save_file_default_ha_ini()
{
  saveStrings("ha.ini", s_default_ha_ini);
  System.out.println("Default file ha.ini has been created.");
}

public void save_file_default_english_lng()
{
   saveStrings("languages/english.lng", s_default_english_lng);
  System.out.println("Default file ./languages/english.lng has been created");
}

public void export_file_shoot_log()
{
  
  s_shootlog_filename = txtShootlog_filename.getText();
  
  s_shootlog_filename += ".slg";
  //System.out.println("txtShootlog_filename: " + s_shootlog_filename);

  s_shoot_log_contain = txtShootLog.getText();
  System.out.println("s_shoot_log_contain: " +s_shoot_log_contain);
  
  s_shootlog_full_filename = "shootlogs/";
  s_shootlog_full_filename += s_shootlog_filename;
  //System.out.println("s_shootlog_full_filename: " + s_shootlog_full_filename);
  //txtShootlog_filename;
  saveStrings(s_shootlog_full_filename, s_shoot_logs);
  System.out.println("Shootlog has been exported into file: " + s_shootlog_full_filename );
}






// This function returns all the files in a directory as an array of Strings  
public String[] listFileNames(String dir)
{
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}



// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
public File[] listFiles(String dir)
{
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

// Function to get a list ofall files in a directory and all subdirectories
public ArrayList listFilesRecursive(String dir)
{
   ArrayList fileList = new ArrayList(); 
   recurseDir(fileList,dir);
   return fileList;
}

// Recursive function to traverse subdirectories
public void recurseDir(ArrayList a, String dir)
{
  File file = new File(dir);
  if (file.isDirectory()) {
    // If you want to include directories in the list
    a.add(file);  
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      // Call this function on all files in this directory
      recurseDir(a,subfiles[i].getAbsolutePath());
    }
  } else {
    a.add(file);
  }
}

public int  number_of_black_diameter, number_of_biggest_diameter, t_black_center_image_size, t_white_border_image_size;
public int t_black_center_image_size_autoscaled, t_white_border_image_size_autoscaled;
public float targets_diameters[];
public int brightestX_high, brightestX_low, brightestY_high, brightestY_low, brightestValue;
public int hit_points_actual =0, hit_points_last = 0, hit_points_sum = 0, hit_counter = 0, delta_X, delta_Y, hit_X, hit_Y, last_hit_Y, last_hit_X, hit_areas_ok = 0;
public float projectile_diameter, txt_projectile_diameter;
public float current_radius, maximum_radius, diameter_scale, diameter_scale_autoscaled, radius_scale, target_scale, center_range = 0, square_max_lenght, square_scale, last_target_scale = 0;
public float A1X_autoscaled = 0, A1Y_autoscaled = 0, A2X_autoscaled = 0, A2Y_autoscaled = 0, B1X_autoscaled = 0, B1Y_autoscaled = 0, B2X_autoscaled = 0, B2Y_autoscaled = 0, CX_autoscaled = 0, CY_autoscaled = 0;
public float A1X = 0, A1Y = 0, A2X = 0, A2Y = 0, B1X = 0, B1Y = 0, B2X = 0, B2Y = 0, CX = 0, CY = 0, areas_width, areas_height, areas_side_ratio;
public float side_A1X, side_A1Y, side_A2X, side_A2Y, side_B1X, side_B1Y, side_B2X, side_B2Y;
public float shift_Y_init;
public void analyze_the_target()
{
  //Recognize target
  //circle target, square circle target
  if(targets_diameters[0] == 0)
    { 
    circle_target_analyze();
    };
  
  //square circle target
  if(targets_diameters[0] == 1)
    { 
    square_circle_target_analyze();
    };
  //for circle target and square circle target
  //radius_scale = diameter_scale / 2;
  t_black_center_image_size_autoscaled = round(targets_diameters[number_of_black_diameter] * diameter_scale);
  t_white_border_image_size_autoscaled = round(targets_diameters[number_of_biggest_diameter] * diameter_scale);

};

public void scale_the_target()
{
  if(target_type == 0)
    { 
    circle_target_scaling();
    };
  if(target_type == 1)
    { 
    square_circle_target_scaling();
    };  
  
}

public void find_position_of_hit()
{
   video.loadPixels();
   // reset position of the brightest pixel
   brightestX_high = 0; 
   brightestY_high = 0;
   brightestX_low = 0;
   brightestY_low = 0;
   brightestValue = 0; // Brightness of the brightest video pixel
  //for best result must be picture monochromatic
  //scanning the picture from top left to botom right
  int index = 0;
  for (int y = 0; y < video_height; y++)
    {
      for (int x = 0; x < video_width; x++)
      {
        // Get the color stored in the pixel
        int pixelValue = video.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // filttering the brightest pixel
        if (pixelBrightness > 254)
        {
         // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        // This select the first brightest pixel
          if (pixelBrightness > brightestValue)
          {
            brightestValue = PApplet.parseInt(pixelBrightness);
            brightestY_high = y;
            brightestX_high = x;
          }
          //This select the last brightest pixel
          brightestY_low = y;
          brightestX_low = x;
        }
        index++;
      }
    }
};


public void calculate_hit_range()
{
  // This calculate the center betwen first and last brightest pixel
  hit_Y = (brightestY_high + brightestY_low) / 2; // X-coordinate of the brightest video pixel
  hit_X = (brightestX_high + brightestX_low) / 2; // Y-coordinate of the brightest video pixel
  hit_Y += (y_projectile_shift * diameter_scale);
  delta_X = target_diameters_center_X + correction_X - hit_X; // plus offset
  delta_Y = target_diameters_center_Y + correction_Y - hit_Y; // plus offset
  // Calculate distance from center
  center_range = sqrt((delta_X * delta_X)+ (delta_Y * delta_Y));
  center_range = round(center_range);
}

public void hit_area_test()
{
 // make border depended on projectile diameter
  //test area A
  //left up corner of area A
  side_A1X = A1X + correction_X;
  side_A1X -= (projectile_diameter * radius_scale);
  side_A1Y = A1Y + correction_Y;
  side_A1Y -= (projectile_diameter * radius_scale);
  //right down corner of area A
  side_A2X = side_A1X + A2X;
  side_A2X += (projectile_diameter * diameter_scale);// side_A1X is shiftet by radius, so its necesary to shift side_A2X with twice radius (diameter)
  side_A2Y = side_A1Y + A2Y;
  side_A2Y += (projectile_diameter * diameter_scale);
  
  if((hit_X > side_A1X) && (hit_Y > side_A1Y))
  {
    if((hit_X < side_A2X) && (hit_Y < side_A2Y))
    {
     hit_areas_ok = 1;
    }
  };
  
  //test area B
  //left up corner of area B
  side_B1X = B1X + correction_X;
  side_B1X -= (projectile_diameter * radius_scale);
  side_B1Y = B1Y + correction_Y;
  side_B1Y -= (projectile_diameter * radius_scale);
  //right down corner of area B
  side_B2X = side_B1X + B2X;
  side_B2X += (projectile_diameter * diameter_scale);
  side_B2Y = side_B1Y + B2Y;
  side_B2Y += (projectile_diameter * diameter_scale);
  
  if((hit_X > side_B1X) && (hit_Y > side_B1Y))
  {
    if((hit_X < side_B2X) && (hit_Y < side_B2Y))
    {
     hit_areas_ok = 1;
    }
  };
  
  
  
  
}



public void hit_points_calculation()
{
  
  //targets_diameters = at_airgun_cz_diameters;  // this will be in combobox targets handeler
  // radius scale make diameters to radius
  maximum_radius = PApplet.parseInt(round((targets_diameters[number_of_biggest_diameter] + projectile_diameter) * radius_scale));
  //hit_area_test();
  
  if(target_type == 0)// cirlce target
  {
    for(int i = 1; i < 11 ;i++ ) 
    {
      current_radius = (targets_diameters[i] + projectile_diameter) * radius_scale;
       if(center_range <= current_radius)
         {
         hit_points_actual = i;
         }
       if(center_range > maximum_radius)
       hit_points_actual = 0;
    }
  };
  
  
  
  if(target_type == 1) //circle square target
  {
    hit_area_test();
    if(hit_areas_ok == 1)
    {
      for(int i = 1; i < 11 ;i++ )
      {
         current_radius = (targets_diameters[i] + projectile_diameter) * radius_scale;
         if(center_range <= current_radius)
           {
           hit_points_actual = i;
           }
        if(center_range > maximum_radius)
        hit_points_actual = 0;
      }
    }
    
    if(hit_areas_ok ==0)
    {
      hit_points_actual = 0;
    }
    hit_areas_ok =0;
  };
  
  
  if(b_Shooting)
  hit_points_sum += hit_points_actual;
};



//target analyze

public void set_number_of_biggest_diameter()
{
   if(targets_diameters[1] != 0)
       {
         number_of_biggest_diameter = 1;
       }
   else for(int i = 1; i <= 9; i++) 
         { 
           //System.out.println("i: " + i);  // numbers of circles
           if(targets_diameters[i] == 0)
           {
             number_of_biggest_diameter = (i + 1);
           }
           else break;
         };
 //System.out.println("Number_of_biggest_diameter: " + number_of_biggest_diameter); 
}


public void circle_target_analyze()
{
  number_of_black_diameter = PApplet.parseInt(targets_diameters[11]);
  diameter_scale_autoscaled = (video_height - 24) / targets_diameters[number_of_biggest_diameter];  //automatic scaling for maximum diameter
  diameter_scale = diameter_scale_autoscaled; //first init diameter_scale
  radius_scale = diameter_scale / 2; //first init radius scale
  target_type = 0;
};


public void square_circle_target_analyze()
{
    float shift_X, shift_Y;
    number_of_black_diameter = PApplet.parseInt(targets_diameters[11]);

    areas_height = A2Y + B2Y;
    //areas width
    if((A1X + A2X) <= B2X)
    {
      areas_width = B2X;
    }
    else
    {
      areas_width =  A1X + A2X;
    };
    
    
    
    //System.out.println("f_resolution_ratio: " + f_resolution_ratio); 
    //System.out.println("areas_width: " + areas_width); 
    //System.out.println("areas_height: " + areas_height); 
    
    //areas side ratio
    areas_side_ratio = areas_width / (areas_height * f_resolution_ratio);
    System.out.println("areas_side_ratio: " + areas_side_ratio); 
    
    if (areas_side_ratio <= 1)
    {
      square_scale = (video_height - 50) / areas_height;
      //System.out.println("square_scale: " + square_scale); 

    }
    else
    {
      square_scale = (video_width - 50) / areas_width;
      //System.out.println("square_scale: " + square_scale); 
    };
    
    A1X_autoscaled = A1X * square_scale;
    A1Y_autoscaled = A1Y * square_scale;
    A2X_autoscaled = A2X * square_scale;
    A2Y_autoscaled = A2Y * square_scale;
    B1X_autoscaled = B1X * square_scale; 
    B1Y_autoscaled = B1Y * square_scale;
    B2X_autoscaled = B2X * square_scale;
    B2Y_autoscaled = B2Y * square_scale;
    CX_autoscaled = CX * square_scale;
    CY_autoscaled = CY * square_scale;
    
    // first init
    A1X = A1X_autoscaled;
    A1Y = A1Y_autoscaled;
    A2X = A2X_autoscaled;
    A2Y = A2Y_autoscaled;
    B1X = B1X_autoscaled; 
    B1Y = B1Y_autoscaled;
    B2X = B2X_autoscaled;
    B2Y = B2Y_autoscaled;
    CX = CX_autoscaled;
    CY = CY_autoscaled;
    

    shift_X = (video_width - (areas_width * square_scale)) / 2;
    shift_Y = (video_height - (areas_height * square_scale)) / 2;
    shift_Y_init = shift_Y;
    A1X += shift_X;
    A1Y += shift_Y;
    B1X += shift_X;
    B1Y += shift_Y;
    
    System.out.println("A1X: " + A1X); 
    System.out.println("A1Y: " + A1Y); 
    System.out.println("A2X: " + A2X); 
    System.out.println("A2Y: " + A2Y); 
    System.out.println("B1Y: " + B1Y); 

    
    
    target_diameters_center_X = (int)(CX + shift_X);
    target_diameters_center_Y = (int)(CY + shift_Y);  
    
    //prepare for methosd target_scale
    A1X_autoscaled = A1X;
    A1Y_autoscaled = A1Y;
    B1X_autoscaled = B1X;
    B1Y_autoscaled = B1Y;



    diameter_scale = square_scale;//first init diameter_scale 
    diameter_scale_autoscaled = diameter_scale;
    


    radius_scale = diameter_scale / 2; //first init radius scale
    target_type = 1; 
}

public void circle_target_scaling()
{
  if(last_target_scale != target_scale)
  {
    diameter_scale = diameter_scale_autoscaled * target_scale;
    radius_scale = diameter_scale / 2;
    last_target_scale = target_scale;
    t_black_center_image_size = round(t_black_center_image_size_autoscaled * target_scale);
    t_white_border_image_size = round(t_white_border_image_size_autoscaled * target_scale);
  }
}

public void square_circle_target_scaling()
{
  //this damm method i did for 5 hours...
  if(last_target_scale != target_scale)
  {
    diameter_scale = diameter_scale_autoscaled * target_scale;
    radius_scale = diameter_scale / 2;
    last_target_scale = target_scale;
    t_black_center_image_size = round(t_black_center_image_size_autoscaled * target_scale);
    t_white_border_image_size = round(t_white_border_image_size_autoscaled * target_scale);
    
    A2X = A2X_autoscaled * target_scale;
    A2Y = A2Y_autoscaled * target_scale;
    A1X = A1X_autoscaled - (((A2X_autoscaled * target_scale) - A2X_autoscaled ) / 2);
    A1Y = A1Y_autoscaled + (CY_autoscaled - (CY_autoscaled * target_scale));


    B2X = B2X_autoscaled * target_scale;
    B2Y = B2Y_autoscaled * target_scale;
    B1X = B1X_autoscaled - (((B2X_autoscaled * target_scale) - B2X_autoscaled ) / 2);
    B1Y = A2Y + A1Y;

  }
}


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "HomeLESS_Hit_Analyzer" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
