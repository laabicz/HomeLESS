/*
This System_methods.pde is part of HomeLESS Hit Analyzer.

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


// bolean, initial value
public boolean b_Configure = true, b_Shooting = false, b_Hit_detected = false, b_show_last_hit = false, b_sound_enabled = false, b_ballistics, b_shortcuts = true, b_shoot_stop = false, b_shooting_prepare = false, b_time_of_shooting_s = false; // Mode
public boolean b_training_style = false, b_hunting_style = false, b_combat_style = false, b_sport_style = false, b_freerun_style = false; //Shooting style
public boolean b_autoshootlog = false, b_autoshootlog_written = true, b_hold_last_hit = false, b_invert_hit_X = false;
public boolean b_monoscope_synchronization_enabled = false;
// limits: 
public boolean b_time_limit = false, b_hit_limit = false;
public int shooting_style;


public byte video_X_offset = 10, video_Y_offset = 50; // position of up left corner of video stream
public int webcam_type, center_video_X, center_video_Y, correction_X = 0, correction_Y = 0, target_diameters_center_X, target_diameters_center_Y;
public int i_delay, i_shooting_prepare, i_shooting_prepare_actual, i_time_of_shooting_s = 0;


// time variables
public boolean b_start_shooting_prepare_countdown_synchronization = false, b_time_of_shooting_counter = false;
public boolean b_show_time_as_countdown = false;
public int i_time_of_shooting_total = 270, i_time_of_shooting_countdown = 0, i_time_of_shooting_actual;  // minutes and seconds together
public int i_time_of_shooting_seconds_total = 30, i_time_of_shooting_minutes_total = 4;
public int i_time_of_shooting_started_millis = 0, i_time_of_shooting_ended_millis, i_time_of_hit_detection_millis = 0;
public float f_time_of_hit_detection_relative = 0;
//public String s_Time_of_shooting_seconds_total, s_Time_of_shooting_minutes_total;
public String s_shooting_time_total, s_shooting_time_actual, s_time_of_hit_detection_relative;
public String s_seconds_actual, s_seconds_total;
public String s_minutes_actual, s_minutes_total;


public int i_sensitivity = 1;
public ArrayList shoot_logs = new ArrayList();
public int shoot_log_counter = 0, new_shooting_start_time, i_Rounds;
public String s_hit_X_temp, s_hit_Y_temp;

public float f_resolution_ratio;
public float f_simulated_distance = 10.0, f_real_distance = 5.0;


public int i_millis_time_actual, i_millis_time_last = 0, i_seconds_time_last = 0;
public float f_delay, f_10delay, f_hit_mark_diameter;
public int i_every_100_ms_timer = 0, i_every_1_second_timer = 0 , i_every_500_ms_timer ;


void system_clock_timer()
{
  /*
  if((millis() - i_millis_time_last) > 100) // every 100 ms , almost :)
    {
      i_every_100_ms_timer++;
      System.out.println("i_every_100_ms_timer: " + i_every_100_ms_timer );
      i_millis_time_last = millis();
      
      if(b_Configure == false)
        {
          new_shooting_start_time--;
        };

      if(new_shooting_start_time <= 0)
        {
        System.out.println("new_shooting ready.");
        b_Shooting = true;
        new_shooting_start_time = i_delay;
        }
      
    };*/
  
  // every one second timing
  if(second() != i_seconds_time_last)
    {
      //i_every_1_second_timer++;
      //System.out.println("i_every_1_second_timer: " + i_every_1_second_timer);
      i_seconds_time_last = second();
      i_every_100_ms_timer = 0;
      
      //i_time_of_shooting_actual;
      //i_time_of_shooting_total;
      
      if(b_time_of_shooting_counter)
        {
          i_time_of_shooting_countdown--;
          
          if(i_time_of_shooting_countdown == 0)
            {
              b_time_of_shooting_counter = false;
            }
          convert_time();
        };
      
      //shooting prepare timer must wait for at least one second
      //for synchronization with system clock.
      if(b_shooting_prepare) //shooting prepare timer
        {
          i_shooting_prepare_actual--; 
          //System.out.println("i_shooting_prepare_actual: " + i_shooting_prepare_actual);
          if(i_shooting_prepare_actual == 0)
            {
              b_Configure = false;
              b_Shooting = true;
              b_shooting_prepare = false;
              b_time_of_shooting_counter = true;
              b_autoshootlog_written = false;
              i_shooting_prepare_actual = i_shooting_prepare;
              i_time_of_shooting_started_millis = millis();
              System.out.println("\nShooting started at time: " + i_time_of_shooting_started_millis);
            } 
        }
      // for synchronization with timers and system clock
      if(b_start_shooting_prepare_countdown_synchronization)
        {
          b_shooting_prepare = true;
          //tmrSecondsTimer_Shooting_Prepare.start(); 
          b_start_shooting_prepare_countdown_synchronization = false;
          //System.out.println("Prepare countdown started.");      
        }; 
    };
    //every one second timing end
    
};


void create_timers()
{
  tmrMilisTimer = new GTimer(this, this, "MilisTimerFunction", 100);
  //tmrSecondsTimer_Shooting_Countdown = new GTimer(this, this, "tmrSecondsTimer_Shooting_Countdown", 1000);
  //tmrSecondsTimer_Shooting_Prepare = new GTimer(this, this, "tmrSecondsTimer_Shooting_Prepare", 1000);
  //tmrTimer.start();
  //tmrTimer.stop();
};


void MilisTimerFunction(GTimer timer) //every 100 ms
{

  new_shooting_start_time--;
  //System.out.println("new_shooting_start_time: " + new_shooting_start_time);
  if((new_shooting_start_time <= 0) && (b_Configure == false) && (b_Shooting == false) && (b_shoot_stop == false))
    {
      b_Shooting = true;
      new_shooting_start_time = i_new_shooting_start_time_start_value;
     // System.out.println("new_shooting ready");
      tmrMilisTimer.stop();
    };  
}



void camera_setup()
{
  println("\nStarting video...\n");
  if(webcam_type == 0)
  {
    //video = new GSCapture(this, video_width, video_height, "/dev/video0");
    video = new Capture(this, video_width, video_height, "/dev/video0");
  }
  else if(webcam_type == 1)
  {
    //video = new GSCapture(this, video_width, video_height, "/dev/video1");
    video = new Capture(this, video_width, video_height, "/dev/video1");
  }
  else if(webcam_type == 2)
  {
    //video = new GSCapture(this, video_width, video_height, "/dev/video2");
    video = new Capture(this, video_width, video_height, "/dev/video2");
  }
  else if(webcam_type == 3)
  {
    //video = new GSCapture(this, video_width, video_height, "/dev/video3");
    video = new Capture(this, video_width, video_height, "/dev/video3");
  }
  else if(webcam_type == 4)
  {
    //video = new GSCapture(this, video_width, video_height, "/dev/video4");
    video = new Capture(this, video_width, video_height, "/dev/video4");
  }
  else if(webcam_type == 5)
  {
    //video = new GSCapture(this, video_width, video_height, "/dev/video5");
    video = new Capture(this, video_width, video_height, "/dev/video5");
  }
  else
  //video = new GSCapture(this, video_width, video_height);
  video = new Capture(this, video_width, video_height);
}


void convert_time()
{
 //float f_seconds;
 //float f_minutes;
 int i_seconds_actual, i_seconds_total;
 int i_minutes_actual, i_minutes_total;
  
  //System.out.println("f_shooting_time: " + f_shooting_time);
  //count from total to zero, move this to convert time method
  
 i_time_of_shooting_actual = (i_time_of_shooting_total - i_time_of_shooting_countdown);
 //System.out.println("b_show_time_as_countdown: " + b_show_time_as_countdown);
 //System.out.println("i_time_of_shooting_actual: " + i_time_of_shooting_actual); 
 
 if(b_show_time_as_countdown)
   {
     i_time_of_shooting_actual = i_time_of_shooting_countdown;
     //System.out.println("b_show_time_as_countdown: " + b_show_time_as_countdown);
     //System.out.println("i_time_of_shooting_actual: " + i_time_of_shooting_actual);
   }
 
 /*
 else //count from zero to total
   {
      i_time_of_shooting_actual = (i_time_of_shooting_total - i_time_of_shooting_countdown);
      System.out.println("b_show_time_as_countdown: " + b_show_time_as_countdown);
      System.out.println("i_time_of_shooting_actual: " + i_time_of_shooting_actual);
   };
  */
  i_seconds_actual = i_time_of_shooting_actual % 60;
  i_minutes_actual = (i_time_of_shooting_actual - i_seconds_actual) / 60 ;
  s_seconds_actual = String.valueOf(nf(i_seconds_actual,2));
  s_minutes_actual = String.valueOf(nf(i_minutes_actual,2));
     
  i_seconds_total = i_time_of_shooting_total % 60;
  i_minutes_total = (i_time_of_shooting_total - i_seconds_total) / 60 ;
  i_time_of_shooting_seconds_total = i_seconds_total;
  i_time_of_shooting_minutes_total = i_minutes_total;
  s_seconds_total = String.valueOf(nf(i_seconds_total,2));
  s_minutes_total = String.valueOf(nf(i_minutes_total,2));


   
 if(b_time_limit == false)
  {
    s_seconds_actual = "--";
    s_minutes_actual = "--";
    s_seconds_total = "--";
    s_minutes_total = "--";
  };           
 /*           
 if(b_time_limit == true)
   {
     //f_seconds = f_shooting_time % 60;
     //f_minutes = (f_shooting_time - f_seconds) / 60 ;
     //s_seconds = String.valueOf(nf((int)f_seconds,2));
     //s_minutes = String.valueOf(nf((int)f_minutes,2)); 
     i_seconds_actual = i_time_of_shooting_actual % 60;
     i_minutes_actual = (i_time_of_shooting_actual - i_seconds_actual) / 60 ;
     i_time_of_shooting_seconds_total = i_seconds_actual;
     i_time_of_shooting_minutes_total = i_minutes_actual;
     s_seconds_actual = String.valueOf(nf(i_seconds_actual,2));
     s_minutes_actual = String.valueOf(nf(i_minutes_actual,2));
     
     i_seconds_total = i_time_of_shooting_total % 60;
     i_minutes_total = (i_time_of_shooting_total - i_seconds_total) / 60 ;
     s_seconds_total = String.valueOf(nf(i_seconds_total,2));
     s_minutes_total = String.valueOf(nf(i_minutes_total,2));
   }
  else
  {
    s_seconds_actual = "--";
    s_minutes_actual = "--";
    s_seconds_total = "--";
    s_minutes_total = "--";
  };
 */

 /*
 i_time_of_shooting_total = (int)f_seconds; // minutes and seconds together
 i_time_of_shooting_seconds_total = i_time_of_shooting_total % 60;
 i_time_of_shooting_minutes_total = (i_time_of_shooting_total - i_time_of_shooting_seconds_total) / 60 ;
 */
 //System.out.println("Total seconds: " + i_time_of_shooting_total);
 //System.out.println("Minutes: " + i_time_of_shooting_minutes_total);
 //System.out.println("Seconds: " + i_time_of_shooting_seconds_total);

 
 s_shooting_time_actual = s_minutes_actual + ":" + s_seconds_actual;
 s_shooting_time_total = s_minutes_total + ":" + s_seconds_total;
 //System.out.println("s_shooting_time_actual: " + s_shooting_time_actual);
 //System.out.println("s_shooting_time_total: " + s_shooting_time_total);
}




void draw_video()
{
  image(video, video_X_offset, video_Y_offset, video_width, video_height);

};



void draw_calibration_ghost_image()
{
  if (b_Configure)
    {
      fill(255, 255, 0, 100);

      //circle target
      if((i_target_type == 0) || (i_target_type == 2))
        {
        //black diameter
        //t_black_center_image_size = round(targets_diameters[number_of_black_diameter] * target_scale);
        ellipse(target_diameters_center_X + video_X_offset + correction_X , target_diameters_center_Y + video_Y_offset + correction_Y, t_black_center_image_size, t_black_center_image_size);
        //white diameter
        //t_white_border_image_size = round(targets_diameters[number_of_biggest_diameter] * target_scale);
        ellipse(target_diameters_center_X + video_X_offset + correction_X , target_diameters_center_Y + video_Y_offset + correction_Y, t_white_border_image_size, t_white_border_image_size);
        };
      
      //square circle target
      if((i_target_type == 1) || (i_target_type == 3) || (i_target_type == 4))
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
  f_hit_mark_diameter = f_projectile_diameter * f_diameter_scale;
  //dia = f_projectile_diameter * f_diameter_scale;
  if(hit_is_in_screen())
    {
      //System.out.println("f_hit is in screen");
      //color of hit
      //fill(255, 0, 0, 255); //red
      fill(0, 0, 160, 255); //blue
      if(f_projectile_diameter == 0)// for middle evaluation
        {
          rect(f_hit_X + video_X_offset - 2, f_hit_Y + video_Y_offset -17, 3, 15); // up
          rect(f_hit_X + video_X_offset - 2, f_hit_Y + video_Y_offset +1, 3, 15); // down
          rect(f_hit_X + video_X_offset - 17, f_hit_Y + video_Y_offset -2, 15, 3); // left
          rect(f_hit_X + video_X_offset + 1, f_hit_Y + video_Y_offset -2, 15, 3); // right
        }
      else
        {// for ambient avaluation
        //dia = f_projectile_diameter * f_diameter_scale;
        ellipse(f_hit_X + video_X_offset, f_hit_Y + video_Y_offset, f_hit_mark_diameter, f_hit_mark_diameter);
        }
    }
};

void draw_shooting_prepare_countdown()
{
  if(b_shooting_prepare == true || b_start_shooting_prepare_countdown_synchronization) //first one second may be little longer... :)
  {
      x_position = ((video_width + video_X_offset)/2) - 60;
      y_position = ((video_height + video_Y_offset)/2) -105;
      fill(0, 0, 160, 255); //blue
      textSize(200);
      text(String.valueOf(i_shooting_prepare_actual), x_position, y_position, 600, 300);
  }
};



void stop_analyze_when_hitcount_overflow()
{
   if((hit_counter == 99)) //value 99
   {
     b_Shooting = false;
     b_shoot_stop = true;
     b_time_of_shooting_s = false;
     x_position = 140;
     y_position = 200;
     fill(255, 0, 0, 255);
     textSize(150);
     text("STOP", x_position, y_position, 600, 300);
     i_time_of_shooting_ended_millis = millis();
     System.out.println("\nShooting ended at time: " + i_time_of_shooting_ended_millis);
   };
};


void stop_analyze_when_hit_detected()
{
  String s_temp;
  if(b_Shooting)
    {
     if(hit_is_in_screen())
       {
         i_time_of_hit_detection_millis = millis();
         f_time_of_hit_detection_relative =  i_time_of_hit_detection_millis - i_time_of_shooting_started_millis; //to get relative time of detected hit
         f_time_of_hit_detection_relative = f_time_of_hit_detection_relative / 1000;//
         s_temp = (nf(f_time_of_hit_detection_relative,4,1)).substring(0,4) + "." + (nf(f_time_of_hit_detection_relative,4,1)).substring(5); //to replace "," by "."
         s_time_of_hit_detection_relative = s_temp;
         //s_time_of_hit_detection_relative = nf((f_time_of_hit_detection_relative / 1000),4,1);
         hit_points_last = hit_points_actual;
         b_Shooting = false;
         if(b_hit_limit == true)
           {
             hit_counter++;
           };
         b_Hit_detected = true;
         last_f_hit_Y = f_hit_Y;
         last_f_hit_X = f_hit_X;
         tmrMilisTimer.start();
         
         System.out.println("\nHit detected:");
       }
    }
    
    //mod obracene detekce
    
};
void draw_last_hit()
{
  if(b_show_last_hit)
  {
    if(last_hit_is_in_screen())
      {
        //fill(255, 255, 50, 255); //yellow
        //fill(0, 0, 160, 255); //blue
        fill(255, 0, 0, 255); //red
        if(f_projectile_diameter == 0)// for middle evaluation
          {
           rect(last_f_hit_X + video_X_offset - 2, last_f_hit_Y + video_Y_offset -17, 3, 15); // up
           rect(last_f_hit_X + video_X_offset - 2, last_f_hit_Y + video_Y_offset +1, 3, 15); // down
           rect(last_f_hit_X + video_X_offset - 17, last_f_hit_Y + video_Y_offset -2, 15, 3); // left
           rect(last_f_hit_X + video_X_offset + 1, last_f_hit_Y + video_Y_offset -2, 15, 3); // right
          }
        else
           ellipse(last_f_hit_X + video_X_offset, last_f_hit_Y + video_Y_offset, f_hit_mark_diameter, f_hit_mark_diameter);        
      }
  }
      
};


void write_to_shoot_log()
{
  String current_shoot_log;

  
  if(b_Hit_detected)
    {
    
    // Add current message
    //shoot_logs.add(nf(shoot_log_counter,2) + " " + "X:" + nf(i_hit_X,4) + " Y:" + nf(i_hit_Y,4) + " P:" + nf(hit_points_actual,2) + " T:" +s_time_of_hit_detection_relative;
    // Join logs messages into one string
    //txtShootLog.setText(join((String[])shoot_logs.toArray(new String[shoot_logs.size()]), '\n'));
    s_hit_X_temp = (nf(f_hit_X,4,1)).substring(0,4) + "." + (nf(f_hit_X,4,1)).substring(5);  //replace "," by "."
    s_hit_Y_temp = (nf(f_hit_Y,4,1)).substring(0,4) + "." + (nf(f_hit_Y,4,1)).substring(5);
    current_shoot_log =  "X:" + s_hit_X_temp + " Y:" + s_hit_Y_temp + " P:" + String.valueOf(nf(hit_points_actual,2)) + " T:" + s_time_of_hit_detection_relative;
    System.out.println(current_shoot_log);
    //s_current_hit_temp
    //current_shoot_log_temp = current_shoot_log;
    
    // 20 lines of header of shootlog file
    s_shoot_logs[shoot_log_counter + 21] = current_shoot_log;  //first some (0~21) lines for shootlog header
    //s_shoot_logs[shoot_log_counter - 1] = current_shoot_log;
    current_shoot_log = "";
    shoot_log_counter++;
    if(b_monoscope_synchronization_enabled)
    {
      shoot_log_counter = 0;
    }
    
  };
  //b_Hit_detected = false;
  // Scroll down until last event is visible.
  //while(txtShootLog.scroll(GTextField.SCROLL_DOWN));
};


void stop_by_limits()
{
  if(b_hit_limit == true)
  {
    if(i_Rounds == hit_counter)
      {
       b_time_of_shooting_counter = false;
       x_position = 140;
       y_position = 200;
       fill(255, 0, 0, 255);
       textSize(150);
       text("STOP", x_position, y_position, 600, 300);
       b_shoot_stop = true;
       tmrMilisTimer.stop();
       i_time_of_shooting_ended_millis = millis();
       System.out.println("\nShooting ended at time: " + i_time_of_shooting_ended_millis);
       if(b_autoshootlog && (b_autoshootlog_written == false))
          {
          export_file_shoot_log();
          //System.out.println("Exporting shootlog...");
         };
      };
  };
  
  if(b_time_limit == true)
  {
    if(i_time_of_shooting_countdown == 0)
      {
       //b_time_of_shooting_counter = false; //this is in timer function - system_clock_timer()
       x_position = 140;
       y_position = 200;
       fill(255, 0, 0, 255);
       textSize(150);
       text("STOP", x_position, y_position, 600, 300);
       b_shoot_stop = true;
       i_time_of_shooting_countdown = i_time_of_shooting_total;
       tmrMilisTimer.stop();
       i_time_of_shooting_ended_millis = millis();
       System.out.println("\nShooting ended at time: " + i_time_of_shooting_ended_millis);
       if(b_autoshootlog && (b_autoshootlog_written == false) && (b_hit_limit == true))
          {
          export_file_shoot_log();
          //System.out.println("Exporting shootlog...");
         };
      };
  };
  

}



public void sensitivity_up()
{
  i_sensitivity++;
  if(i_sensitivity > 99)
    {
      i_sensitivity = 99;
    }    
}

public void sensitivity_down()
{
   i_sensitivity--;
   if(i_sensitivity < 1)
     {
       i_sensitivity = 1;
     }
}


public void reset_to_config()
{
  // delete contain of infobox
  /*
  for(int i = 0 ; i < shoot_log_counter ; i++ )
     {
     shoot_logs.remove(0);  // this remove last one
     };
     txtShootLog.setText("");
  */
  
     shoot_log_counter = 0;
     //from delete button
     hit_points_actual = 0;
     hit_points_sum = 0;
     hit_counter = 0;
     hit_points_last = 0;
     last_f_hit_X = -5000;
     last_f_hit_Y = -5000;
     f_hit_X = -5000;
     f_hit_Y = -5000;
     //tmrSecondsTimer_Shooting_Countdown.stop();
     //tmrMilisTimer.stop();
     
     b_shoot_stop = false;
     b_Shooting = false;
     b_Configure = true;
     b_time_of_shooting_counter = false;
     //cbxConfigure.setSelected(true);

     
     //f_shooting_time = Float.parseFloat(txtShooting_Time.getText()); // this is error
     //System.out.println("f_shooting_time: " + f_shooting_time);
     
     b_time_of_shooting_s = false;
     i_time_of_shooting_countdown = i_time_of_shooting_total;
     convert_time();
     i_time_of_shooting_s = 0;
  
  
};




void handleToggleControlEvents(GToggleControl option, GEvent event)
{ 
    
  if(option == optTraining)
  {
    b_training_style = true;
    b_hunting_style = false;
    b_combat_style = false;
    b_sport_style = false;
    shooting_style = 1;
    s_current_shooting_style = "Training";
  }
  else if(option == optSport)
  {
    b_training_style = false;
    b_hunting_style = false;
    b_combat_style = false;
    b_sport_style = true;
    shooting_style = 2;
    f_10delay = 1;
    new_shooting_start_time = i_delay;
    s_current_shooting_style = "Sport";
  } 
  
  /*
  else if(option == optCombat)
  {
    b_training_style = false;
    b_hunting_style = false;
    b_combat_style = true;
    b_sport_style = false;
    shooting_style = 3;
  } 
  else if(option == optHunting)
  {
    b_training_style = false;
    b_hunting_style = true;
    b_combat_style = false;
    b_sport_style = false;
    shooting_style = 4;
    f_10delay = 1;
    new_shooting_start_time = i_delay;
  };
   */
}




//new
void handleButtonEvents(GImageButton button, GEvent event)
{
  b_shortcuts = true;// to activate key shortcuts
  
  if(b_Configure)   //remove this into button handlers
  {
    if(button == btnCorrection_down)// 
     {
       correction_Y++;
     };
     
    if(button == btnCorrection_left)// 
     {
       correction_X--;
     };
     
    if(button == btnCorrection_right)// 
     {
       correction_X++;
     };
   
    if(button == btnCorrection_up)// 
     {
      correction_Y--;
     };
     
     
    if(button == btnCorrection_reset)// 
     {
       correction_Y = 0;
       correction_X = 0;
     };
     
     if(button == btnMinus)// 
      {
       target_scale -= 0.01;
      };
    
    if(button == btnPlus)// 
     {
       target_scale += 0.01;
     }; 
     
     
    if(button == btnScale_reset)// 
     {
       target_scale = 1;
     }; 
     
     if(button == btnTarget_sync)// 
     {
       send_target_data();
     }; 
     
     
     if(button == btnSensitivity_up)// 
     {
       sensitivity_up();
     }; 
     
    if(button == btnSensitivity_down)// 
     {
       sensitivity_down();
     };
     
     if(button == btnAmplify_down)// 
     {
       amplify_down();
     };
     
    if(button == btnAmplify_up)// 
     {
       amplify_up();
     };
     
    if(button == btnLetsFire) //
      {
        //new_shooting_start_time = i_delay;
        reset_to_config();
        b_start_shooting_prepare_countdown_synchronization = true;
      }
   
     if(button == btn_Win_target_settings)
       {
         createwindowWeapon_target_settings();
       }

    if(button == btnWeapon_settings)
      {
      createwindowWeapon_settings();
      };     
  
    
    if(button == btnSave_gun)
      {
      save_weapon_file();
      save_file_ha_ini();
      };     
    
    if(button == btnGeneral_settings)// && button.eventType == GButton.CLICKED)
      {
       createWindowGeneral_settings();
      }
     
    if(button == btnSave_general)// && button.eventType == GButton.CLICKED)
    {
     save_file_ha_ini();
    };
    
    if(button == btnSave_target)// && button.eventType == GButton.CLICKED)
    {
     save_file_ha_ini();
    };
   
    
  if(button == btnHit_sight_offset_Y_up)
    {
    f_hit_sight_offset_Y--;
    };
 
  if(button == btnHit_sight_offset_X_left)
    {
    f_hit_sight_offset_X--;
    }; 
 
  if(button == btnHit_sight_offset_Y_down)
    {
    f_hit_sight_offset_Y++;
    }; 

  if(button == btnHit_sight_offset_X_right)
    {
    f_hit_sight_offset_X++;
    };
   
  if(button == btnHit_sight_offset_zero)
    {
    f_hit_sight_offset_X = 0;
    f_hit_sight_offset_Y = 0;
    };
    
  if(button == btnHit_sight_autocenter)
    {
    f_hit_sight_offset_X = 0;
    f_hit_sight_offset_Y = 0;
    f_hit_sight_offset_X = (target_diameters_center_X + correction_X) - last_f_hit_X_without_offset;
    f_hit_sight_offset_Y = (target_diameters_center_Y + correction_Y) - last_f_hit_Y_without_offset;
    };
   
   

     
   }// end of config mode, b_configure == false
   
   if(button == btnReset)//
   {
     reset_to_config();
   };
 
 
   if(button == btnScrollUp)// 
     {
     //txtShootLog.scroll(GTextField.SCROLL_UP);
     };
   
   if(button == btnScrollDown)// 
     {
     //txtShootLog.scroll(GTextField.SCROLL_DOWN);
     };
     
   
   
   if(button == btnExport)// && button.eventType == GButton.CLICKED)
    {
     export_file_shoot_log();
    };
  
  

    
}

public void handleTextEvents(GEditableTextControl textcontrol, GEvent event)
{ 
  /*
  switch(event)
  {
  case CHANGED:
    System.out.println("CHANGED");
    break;
  case SELECTION_CHANGED:
    System.out.println("SELECTION_CHANGED");
    break;
  case ENTERED:
    System.out.println("b_shortcuts = false;");
    b_shortcuts = false;
    break;
  default:
    System.out.println("UNKNOWN");
  }
  */
}


/*
void handleTextEvents(GTextField textfield,GEvent event)
{
 //void
};
*/





/*
void handle_txtShootLog(GTextField textfield, GEvent event)
{
  if(textfield.eventType == GTextField.CHANGED)
    {
    b_shortcuts = false;
    }
}
*/

void handle_txtShootlog_filename(GTextField textfield, GEvent event)
{
    switch(event)
    {
    case CHANGED: 
      b_shortcuts = false;
      break;
    case ENTERED:
      s_Shooter_name = txtShootlog_filename.getText();
      break;
    }
  s_Shooter_name = txtShootlog_filename.getText();
 
};


void keyPressed()
{
  if(b_shortcuts == true)
  {
  
    //see ASCII
    if( key == 114 )  // key == r
    {
      reset_to_config();
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
       
       
        if( keyCode == 33)  // key == PageUp
        {
         sensitivity_up();
        }
        
        if( keyCode == 34)  // key == PageDown
        {
         sensitivity_down();  
        }       
       
      }// end of keycode sequence 
      
      
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
     
      if( key == 109 && b_Configure)  // key == m
      {    
        amplify_up();
      }   
     
      if( key == 110 && b_Configure)  // key == n
      {    
        amplify_down();
      } 
      
      if( key == 103 && b_Configure)  // key == g
      {    
        amplify_reset();
      } 
   
     
    }
  }// end of if(shortcuts)

};

