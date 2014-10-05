/*
This win_general_settings.pde is part of HomeLESS Hit Analyzer.

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

GLabel lblTime, lblShooter, lblAutoshootlog, lblSensitivity;
GLabel lblTimelimit, lblHitslimit, lblCount_up, lblCount_down, lblRear_cam, lblCountdown_timer;
GCheckbox cbxAutoshootlog, cbxLimitedbytime, cbxLimitedbyhits, cbxCountdown_timer, cbxRearcam;
GTextField txtShooting_Time_Minutes, txtShooting_Time_Seconds, txtRounds;
GImageButton btnSave_general;
public String s_Hit_limits,  s_Time_limit, s_Countdown,  s_Autoshootlog, s_Rear_cam;

public void createWindowGeneral_settings()
{ 
  
  windowGeneral_settings = new GWindow(this, "HA - General Settings", 800, 200, 380, 160, false, JAVA2D);
  PApplet win_general = windowGeneral_settings.papplet;
  
  windowGeneral_settings.setActionOnClose(GWindow.CLOSE_WINDOW);
  
  //shooter name (shooter file dropdownlist at future... :) )
  x_position = 10;
  y_position = 10;
  lblShooter = new GLabel(win_general, x_position, y_position, 75, 20);
  lblShooter.setText(s_Shooter + s_colon_with_space);
  lblShooter.setTextAlign(GAlign.LEFT, GAlign.MIDDLE );
  lblShooter.setOpaque(false);
  x_position += 80;
  txtShootlog_filename = new GTextField(win_general, x_position, y_position, 80, 18);
  txtShootlog_filename.setText(s_Shooter_name);
  txtShootlog_filename.addEventHandler(this, "handle_txtShootlog_filename");

  //limited by hits (rounds)
  x_position = 10;
  y_position = 45;
  cbxLimitedbyhits = new GCheckbox(win_general, x_position, y_position, 22, 18, " ");
  cbxLimitedbyhits.setSelected(b_hit_limit);
  cbxLimitedbyhits.addEventHandler(this, "cbxLimitedbyhits_clicked");
  x_position += 20;
  lblHitslimit = new GLabel(win_general, x_position, y_position, 80, 20);
  lblHitslimit.setTextAlign(GAlign.LEFT, GAlign.MIDDLE );
  lblHitslimit.setText(s_Hit_limits + s_colon_with_space);
  lblHitslimit.setOpaque(false);
  x_position += 90;
  txtRounds = new GTextField(win_general, x_position, y_position, 25, 20);
  txtRounds.setText(String.valueOf(i_Rounds));
  txtRounds.addEventHandler(this, "handle_txtRounds");
    
  //limited by time
  x_position = 10;
  y_position = 70;
  cbxLimitedbytime = new GCheckbox(win_general, x_position, y_position, 22, 18, " ");
  cbxLimitedbytime.setSelected(b_time_limit);  //checked depending on time limit
  cbxLimitedbytime.addEventHandler(this, "cbxLimitedbytime_clicked");
  x_position += 20;
  lblTimelimit = new GLabel(win_general, x_position, y_position, 80, 20);
  lblTimelimit.setTextAlign(GAlign.LEFT, GAlign.MIDDLE );
  lblTimelimit.setText( s_Time_limit + s_colon_with_space );
  lblTimelimit.setOpaque(false);
  x_position += 90;
  txtShooting_Time_Minutes = new GTextField(win_general, x_position, y_position, 40, 20);
  txtShooting_Time_Minutes.setText(String.valueOf(i_time_of_shooting_minutes_total));
  txtShooting_Time_Minutes.addEventHandler(this, "handle_txtShooting_Time_Minutes");
  x_position += 50;
  txtShooting_Time_Seconds = new GTextField(win_general, x_position , y_position, 25, 20);
  txtShooting_Time_Seconds.setText(String.valueOf(i_time_of_shooting_seconds_total));
  txtShooting_Time_Seconds.addEventHandler(this, "handle_txtShooting_Time_Seconds");
  
  //countdown timer enable
  x_position = 10;
  y_position = 95;
  cbxCountdown_timer = new GCheckbox(win_general, x_position, y_position, 22, 18, " ");
  cbxCountdown_timer.setSelected(b_show_time_as_countdown);  //checked depending on time limit
  cbxCountdown_timer.addEventHandler(this, "cbxCountdown_timer_clicked");
  x_position += 20;
  lblCountdown_timer = new GLabel(win_general, x_position, y_position, 80, 20);
  lblCountdown_timer.setTextAlign(GAlign.LEFT, GAlign.MIDDLE );
  lblCountdown_timer.setText(s_Countdown); 
  lblCountdown_timer.setOpaque(false);
  
  //autoshootlog   
  x_position = 10;
  y_position = 120;
  cbxAutoshootlog = new GCheckbox(win_general, x_position, y_position, 22, 18, " ");
  cbxAutoshootlog.setSelected(b_autoshootlog);
  cbxAutoshootlog.addEventHandler(this, "cbxAutoshootlog_clicked");
  x_position += 20;
  lblAutoshootlog = new GLabel(win_general, x_position, y_position, 120, 20);
  lblAutoshootlog.setText(s_Autoshootlog);
  lblAutoshootlog.setTextAlign(GAlign.LEFT, GAlign.MIDDLE );
  lblAutoshootlog.setOpaque(false);
  
   
  
  
  
  // sensitivity settings
  x_position = 230;
  y_position = 10;
  lblSensitivity = new GLabel(win_general, x_position, y_position, 80, 20);
  lblSensitivity.setText(s_Sensitivity + s_colon_with_space);
  lblSensitivity.setTextAlign(GAlign.LEFT, GAlign.MIDDLE );
  lblSensitivity.setOpaque(false);
  x_position += 80;
  y_position -= 2;
  images = new String[]{ "graphics/sensitivity_down_1.png", "graphics/sensitivity_down_2.png", "graphics/sensitivity_down_3.png" };
  btnSensitivity_down = new GImageButton(win_general, x_position, y_position, images);
  btnSensitivity_down.tag = "Sensitivity_down";  
  x_position += 30;
  images = new String[]{ "graphics/sensitivity_up_1.png", "graphics/sensitivity_up_2.png", "graphics/sensitivity_up_3.png" };
  btnSensitivity_up = new GImageButton(win_general, x_position, y_position, images);
  btnSensitivity_up.tag = "Sensitivity_up";
  y_position += 30;
  
  
  //rearcam settings
  x_position = 225;
  y_position = 40;
  cbxRearcam = new GCheckbox(win_general, x_position, y_position, 22, 18, "");
  cbxRearcam.setSelected(b_invert_hit_X);
  cbxRearcam.addEventHandler(this, "cbxRearcam_clicked");
  x_position += 20;
  lblRear_cam = new GLabel(win_general, x_position, y_position, 120, 20);
  lblRear_cam.setText(s_Rear_cam);
  lblRear_cam.setTextAlign(GAlign.LEFT, GAlign.MIDDLE );
  lblRear_cam.setOpaque(false);
  

  x_position = 290;
  y_position = 120;
  images = new String[]{ "graphics/save_1.png", "graphics/save_2.png", "graphics/save_3.png" };
  btnSave_general = new GImageButton(win_general, x_position, y_position, images);
  btnSave_general.tag = "Save_general";  

  
  
}



void handle_txtShooting_Time_Seconds(GTextField textfield, GEvent event)  //Time
{
    switch(event)
    {
    case CHANGED: 
      b_shortcuts = false;
      break;
    case ENTERED:
      check_inserted_time_values_limits();
      calculate_time_of_shooting_total();
      convert_time();
      //f_shooting_time = Float.parseFloat(txtShooting_Time_Seconds.getText());
      //System.out.println("i_time_of_shooting_seconds_total: " + i_time_of_shooting_seconds_total);
      break;
    }
};


void handle_txtShooting_Time_Minutes(GTextField textfield, GEvent event)  //Time
{
   //int i_shooting_time_minutes; 
  
    switch(event)
    {
    case CHANGED: 
      b_shortcuts = false;
      break;
    case ENTERED:
      check_inserted_time_values_limits();
      calculate_time_of_shooting_total();
      convert_time();
      //f_shooting_time = Float.parseFloat(txtShooting_Time_Seconds.getText());
      //f_shooting_time = f_shooting_time  + (i_time_of_shooting_minutes_total * 60);
      break;
    }
};

//Hit limit
void handle_txtRounds(GTextField textfield, GEvent event)
{
    switch(event)
    {
    case CHANGED: 
      b_shortcuts = false;
      break;
    case ENTERED:
      i_Rounds = Integer.parseInt(txtRounds.getText());
      if(i_Rounds > 99)
        {
          i_Rounds = 99;
          txtRounds.setText(String.valueOf(i_Rounds));
          System.out.println("\nWARNING: Value of Rounds cannot be higher than 99.");
        }
      System.out.println("\nNew value of Rounds is set to : " + i_Rounds + " rounds." );
      break;
    }
};


public void cbxRearcam_clicked(GCheckbox source, GEvent event)
{ 
  //println("cbxRearcam_clicked - GCheckbox event occured " + System.currentTimeMillis()%10000000 );
  

      if(b_invert_hit_X == true)
        {
          b_invert_hit_X = false;
          System.out.println("\nRearcam disabled. X-axis of hit is NOT inverted.");
        }
      else  //if(b_invert_hit_X == false)
        {
          b_invert_hit_X = true;
          System.out.println("\nRearcam enabled. X-axis of hit is inverted.");
        };
};

public void cbxLimitedbyhits_clicked(GCheckbox source, GEvent event)
{ 
  //println("cbxLimitedbyhits_clicked - GCheckbox event occured " + System.currentTimeMillis()%10000000 );
  if(b_hit_limit == false)
    {
      b_hit_limit = true;
      System.out.println("\nHit limit enabled.");
    }
  else  //if(b_invert_hit_X == false)
    {
      b_hit_limit = false;
      System.out.println("\nHit limit disabled.");
    };
};




public void cbxLimitedbytime_clicked(GCheckbox source, GEvent event)
{ 
  //System.out.println("cbxLimitedbytime_clicked - GCheckbox event occured " + System.currentTimeMillis()%10000000 );
  if(b_time_limit == false)
    {
      b_time_limit = true;
      System.out.println("\nTime limit enabled.");
    }
  else  //if(b_invert_hit_X == false)
    {
      b_time_limit = false;
      System.out.println("\nTime limit disabled.");
    };
  
  check_inserted_time_values_limits();
  calculate_time_of_shooting_total();
  convert_time();
  
};
  
public void cbxCountdown_timer_clicked(GCheckbox source, GEvent event)
{ 
  //System.out.println("cbxCountdown_timer_clicked - GCheckbox event occured " + System.currentTimeMillis()%10000000 );
  if(b_show_time_as_countdown == false)
    {
      b_show_time_as_countdown = true;
      System.out.println("\nCountdown enabled.");
    }
  else  //if(b_invert_hit_X == false)
    {
      b_show_time_as_countdown = false;
      System.out.println("\nCountdown disabled.");
    };
    convert_time();
};





public void cbxAutoshootlog_clicked(GCheckbox source, GEvent event)
{ 
  //System.out.println("Autoshotlog clicked \n");
  
  if(b_autoshootlog == false)
    {
      b_autoshootlog = true;
      System.out.println("\nAutoshootlog enabled.");
    }
  else  //if(b_invert_hit_X == false)
    {
      b_autoshootlog = false;
      System.out.println("\nAutoshootlog disabled.");
    };
  //b_autoshootlog = true;
  //b_autoshootlog = false;
};




void check_inserted_time_values_limits()
{
  i_time_of_shooting_seconds_total =  Integer.parseInt(txtShooting_Time_Seconds.getText());
  i_time_of_shooting_minutes_total = Integer.parseInt(txtShooting_Time_Minutes.getText());
  
  if(i_time_of_shooting_minutes_total > 999)
     {
       i_time_of_shooting_minutes_total = 999;
       System.out.println("\nWARNING: Value of Minutes cannot be higher than 999.");
     };

  if(i_time_of_shooting_seconds_total > 59)
     {
       i_time_of_shooting_seconds_total = 59;
       System.out.println("\nWARNING: Value of Seconds cannot be higher than 59.");
     };
  
  txtShooting_Time_Seconds.setText(String.valueOf(i_time_of_shooting_seconds_total));
  txtShooting_Time_Minutes.setText(String.valueOf(i_time_of_shooting_minutes_total));
};

void calculate_time_of_shooting_total()
{
   i_time_of_shooting_total = i_time_of_shooting_minutes_total * 60;
   i_time_of_shooting_total += i_time_of_shooting_seconds_total;
   i_time_of_shooting_countdown = i_time_of_shooting_total;
   
   //temporary
   //f_shooting_time = (float)i_time_of_shooting_total;
   i_time_of_shooting_actual = i_time_of_shooting_total;
   //System.out.println("Shooting_time Minutes: " + i_time_of_shooting_minutes_total);
   //System.out.println("Shooting_time seconds : " + i_time_of_shooting_seconds_total);
   //System.out.println("Shooting_time total : " + i_time_of_shooting_total);
   //System.out.println("Shooting_time total old: " + f_shooting_time);
}

