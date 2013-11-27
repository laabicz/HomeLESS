
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




void draw_position_of_hit()
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


void handleOptionEvents(GOption selOpt, GOption delselOpt)
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


void handleButtonEvents(GButton button)
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

void handleImageButtonEvents(GImageButton imagebutton)
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
       target_scale -= 0.01;
      };
    
    if(imagebutton == btnPlus)// 
     {
       target_scale += 0.01;
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

void handleTextFieldEvents(GTextField textfield)
{
 //void
};

void handle_txtCaliber(GTextField textfield)
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


void handle_txtShooting_Time(GTextField textfield)  //Time
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


void handle_txtDuration(GTextField textfield)
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

void handle_txtTarget_number(GTextField textfield)
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


void handle_txtShootLog(GTextField textfield)
{
  if(textfield.eventType == GTextField.CHANGED)
    {
    b_shortcuts = false;
    }
}

void handle_txtShootlog_filename(GTextField textfield)
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
        target_scale += 0.01;
      }
      
      if( key == 45 && b_Configure)  // key == -
      {
        target_scale -= 0.01;
      }
      
      if( key == 42 && b_Configure)  // key == *
      {
        target_scale = 1;
      }
      
    }
  }// end of if(shortcuts)

};

