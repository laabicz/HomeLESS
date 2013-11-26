/*
This GUI_methods.pde is part of HomeLESS Hit Analyzer.

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
public int x_position, y_position, lenght;
public int backround_color = 180;
public int video_width = 640, video_height = 480;
public int x_window_size, y_window_size; 
//language pack
public String s_Correction,s_Caliber,s_Infobox,s_Duration,s_Targets_list,s_New_shoot,s_Target_select,s_Sound,s_SLH,s_Lets_fire,s_Time,s_Reset,s_Export,s_Points,s_Hits,s_Total,s_Target,s_About,s_found_target_files, s_Save, s_Shooting_style, s_Training, s_Sport, s_Combat, s_Hunting, s_Shooter;
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




public void create_correction_buttons()
{
  x_position = video_width + 60;
  y_position = 105;
  fill(0, 0, 0, 255);
  textSize(16);
  text(s_Correction, x_position -30 , y_position - 55, 200, 30);
  
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


public void create_sensitivity_buttons()
{
    
  x_position = video_width + 30;
  y_position = 140;
  fill(0, 0, 0, 255);
  textSize(16);
  text(s_Sensitivity, x_position, y_position, 200, 30);
 
  images = new String[]{ "graphics/sensitivity_down_1.png", "graphics/sensitivity_down_2.png", "graphics/sensitivity_down_3.png" };
  btnSensitivity_down = new GImageButton(this,"sensitivity_down",images, x_position, y_position +25);
  btnSensitivity_down.tag = "Sensitivity_down";  

  images = new String[]{ "graphics/sensitivity_up_1.png", "graphics/sensitivity_up_2.png", "graphics/sensitivity_up_3.png" };
  btnSensitivity_up = new GImageButton(this,"sensitivity_down",images, x_position +30, y_position +25);
  btnSensitivity_up.tag = "Sensitivity_up";
}


public void create_shooting_conditions()
{
  x_position = video_width + 170;
  y_position = 75;
  fill(0, 0, 0, 255);
  textSize(16);
  text(s_Conditions, x_position-5, y_position -25, 200, 30);
  text(s_Caliber, x_position, y_position, 200, 30);
  txtCaliber = new GTextField(this, String.valueOf(txt_projectile_diameter), x_position + 80, y_position, 60, 20);
  txtCaliber.addEventHandler(this, "handle_txtCaliber");
  text(s_Time, x_position, y_position +30, 200, 30);
  txtShooting_Time = new GTextField(this, String.valueOf(f_shooting_time), x_position + 80 , y_position + 30, 60, 20);
  txtShooting_Time.addEventHandler(this, "handle_txtShooting_Time");
  text(s_Duration, x_position, y_position + 60, 200, 30);
  txtDuration = new GTextField(this, String.valueOf(duration), x_position + 80, y_position + 60, 60, 20);
  txtDuration.addEventHandler(this, "handle_txtDuration");
  
};

public void create_target_selection_combo()
{
  x_position = video_width + 160;
  y_position = 200;
  fill(0, 0, 0, 255);
  textSize(16);
  cboTarget_selection = new GCombo(this, s_targets_names, 3, x_position, y_position, 150);
  text(s_Target_select, x_position - 130 , y_position , 130, 30);
  
 
  for (int i = 1 ; i <= i_number_of_tgt_files; i++) // get index of selected target
  {

    if(s_selected_target_name.equals(s_targets_names[i]))
      {
      cboTarget_selection.setSelected(i-1);    
      }  
  } 
  
  
  //cboTarget_selection.setSelected(0);
  
};


public void create_button_save_changes()
{
  x_position = video_width + 30;
  y_position = 235;
  fill(0, 0, 0, 255);
  textSize(16);
  btnSave = new GButton(this, s_Save , x_position, y_position, 120, 25);
  btnSave.tag = "Save";
};




public void create_shooting_style_option()
  {
 

    x_position = video_width + 30;
    y_position = 295;
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

public void createWindowTargetsList()
{ 
  x_position = 10;
  y_position = 20;
  windowTargetsList = new GWindow[1];
  windowTargetsList[0] = new GWindow(this, s_Targets_list, x_position, y_position,200,200,false, JAVA2D);
  windowTargetsList[0].setBackground(backround_color +30);
  windowTargetsList[0].addDrawHandler(this, "windowDraw");
  windowTargetsList[0].addMouseHandler(this, "windowMouse");
  //windowDraw();
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
  y_position = 350;
  btnLetsFire = new GButton(this, s_Lets_fire , x_position, y_position, 110, 25);
  btnLetsFire.tag = "Let's fire";
};

public void create_button_Reset_Values()
{
  x_position = video_width + 230;
  y_position = 350;
  btnReset = new GButton(this, s_Reset , x_position, y_position, 80, 25);
  btnReset.tag = "Reset";
};


public void create_ShootLog_interface()
{
  x_position = video_width + 30;
  y_position = 420;
  textSize(16);
  text(s_Infobox, x_position , y_position -25, 100, 25);
  txtShootLog = new GTextField(this, "", x_position, y_position, 280, 150, true);
  txtShootLog.addEventHandler(this, "handle_txtShootLog");
  
  text(s_Shooter, x_position , y_position + 156, 120, 25);
  txtShootlog_filename = new GTextField(this, "Anonymous", x_position +70 , y_position +155, 120, 25);
  txtShootlog_filename.addEventHandler(this, "handle_txtShootlog_filename");
  
  btnExport = new GButton(this, s_Export , x_position + 200, y_position +155, 80, 25);
  btnExport.tag = "Export";
  
  
  images = new String[]{ "graphics/scroll_up_1.png", "graphics/scroll_up_2.png", "graphics/scroll_up_3.png" };
  btnScrollUp = new GImageButton(this,"ScrollUp",images, x_position + 256 , y_position);
  btnScrollUp.tag = "ScrollUp";
  
  
  images = new String[]{ "graphics/scroll_down_1.png", "graphics/scroll_down_2.png", "graphics/scroll_down_3.png" };
  btnScrollDown = new GImageButton(this,"scroll_down",images, x_position + 256 , y_position +126);
  btnScrollDown.tag = "ScrollUp";
  
  //first claering shootlog file
  for(int index = 0; index < 145; index++)
   {
     s_shoot_logs[index] = "";
   }
  
  
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
  y_position = video_height + video_Y_offset;
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

public void draw_sensitivity()
{
  if(b_Configure == true)
  {
  //x_position = video_width +video_X_offset - 250 ;
  //y_position = video_height + video_Y_offset - 25;
  x_position = video_X_offset + 10;
  y_position = video_Y_offset + 8;
  fill(255, 0, 0, 255);
  textSize(24);
  text(s_Sensitivity + nf(i_sensitivity,2) , x_position, y_position, 250, 300);
  } 
}



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

