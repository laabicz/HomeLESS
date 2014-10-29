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
along with HomeLESS Hit Analyzer.  If not, see <http://www.gnu.org/licenses/>.
*/
public int x_position, y_position, lenght;
public int backround_color = 180;
public int video_width = 640, video_height = 480;
int x_window_size, y_window_size; 

public int count;
//language pack
public String s_Correction, s_Caliber, s_Rounds, s_SLH, s_Lets_fire, s_Time, s_Points, s_Hits, s_Total;
public String s_rounds_hits, s_Target, s_About, s_Shooter;
public String s_shooting_time, s_shooting_prepare;
String[] images;
//unused
//s_found_target_files, , s_Save, s_Shooting_style, s_Training, s_Sport, s_Combat, s_Hunting, , s_Infobox
// s_Targets_list, s_New_shoot, s_Target_select, s_Sound, s_Reset, s_Export


void create_window()
{
  if(video_height == 480) //640*480
   {
    x_window_size = video_width + 275;
    y_window_size = video_height + 130;
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



void create_button_win_genereal_settings()
{
  x_position = video_width + 20;
  y_position = 250;
  images = new String[] { "graphics/general_settings_1.png", "graphics/general_settings_2.png", "graphics/general_settings_3.png" };
  btnGeneral_settings = new GImageButton(this, x_position, y_position, images);
  btnGeneral_settings.tag = "general_settings";

}


void create_button_win_target_settings()
{
  x_position = video_width + 105;
  y_position = 250;

  
  //fill(0, 0, 0, 255);
  //textSize(16);
  //text(s_Correction, x_position, y_position, 150, 30);
  images = new String[] { "graphics/target_settings_1.png", "graphics/target_settings_2.png", "graphics/target_settings_3.png" };
  btn_Win_target_settings = new GImageButton(this, x_position, y_position, images);
  btn_Win_target_settings.tag = "Win_target_settings";
}



void create_button_win_weapon_settings()
{
  x_position = video_width + 190;
  y_position = 250;
  images = new String[]{ "graphics/weapon_settings_1.png", "graphics/weapon_settings_2.png", "graphics/weapon_settings_3.png" };
  btnWeapon_settings = new GImageButton(this, x_position, y_position, images);
  btnWeapon_settings.tag = "Weapon_settings";  
}


void create_button_Lets_Fire()
{
  x_position = video_width + 20;
  y_position = 290;
  images = new String[]{ "graphics/letsfire_1.png", "graphics/letsfire_2.png", "graphics/letsfire_3.png" };
  btnLetsFire = new GImageButton(this, x_position, y_position, images);
  btnLetsFire.tag = "Let's fire";  

};




void create_button_Reset_Values()
{
  x_position = video_width + 190;
  y_position = 290;
  images = new String[]{ "graphics/reset_1.png", "graphics/reset_2.png", "graphics/reset_3.png" };
  btnReset = new GImageButton(this, x_position, y_position, images);
  btnReset.tag = "Reset";  
};


void create_Export_interface()
{
  x_position = video_width + 105;
  y_position = 290;
  textSize(16);
  fill(0, 0, 0, 255);
  
  images = new String[]{ "graphics/export_shootlog_1.png", "graphics/export_shootlog_2.png", "graphics/export_shootlog_3.png" };
  btnExport = new GImageButton(this, x_position, y_position, images);
  btnExport.tag = "ExportShootlog";  

  for(int index = 0; index < 145; index++)
   {
     s_shoot_logs[index] = "";
   }
  
  
};


void create_about_text()
{
  x_position = x_window_size - 320;
  y_position = y_window_size  -25;
  textSize(16);
  text(s_About, x_position , y_position , 400, 50);
};


void draw_current_target()
{
  x_position = video_X_offset;
  y_position = 0;
  fill(backround_color);  
  rect(x_position, y_position, 520, video_Y_offset);
  textSize(40);
  fill(0, 170, 30, 255);
  text(s_Target + s_colon_with_space + target_name, x_position, y_position, 600, 100);
};

void draw_time()
{
  
  x_position = video_width + 20;
  y_position = 0;
  fill(backround_color);  
  rect(x_position, y_position, 260, video_Y_offset);
  textSize(40);
  fill(0, 170, 30, 255);
  text(s_Time  + s_colon_with_space , x_position , y_position , 230, 50);
  fill(255, 0, 0, 255);
  //convert_time();
  text(s_shooting_time_actual, x_position + 120 , y_position , 230, 50);
}

void draw_count()
{
  x_position = 260;
  y_position = 160;
  fill(0, 0, 0, 255);
  //textSize(24);
  textSize(200);
  text("" + count, x_position, y_position, 600, 300);
}


void draw_hold_last_hit()
{
  if(b_show_last_hit)
  {
    //
    if(hit_without_sight_offset_is_in_screen())
      {
      last_f_hit_X = f_hit_X;
      last_f_hit_Y = f_hit_Y;
      last_f_hit_X_without_offset = last_f_hit_X - f_hit_sight_offset_X;
      last_f_hit_Y_without_offset = last_f_hit_Y - f_hit_sight_offset_Y; 
      }
     
    
    // draw last hit without offset
    if(last_hit_without_sight_offset_is_in_screen())
       {
          fill(0, 170, 30, 255); //green
          if(f_projectile_diameter == 0)// for middle evaluation
            {
              rect(last_f_hit_X_without_offset + video_X_offset - 2, last_f_hit_Y_without_offset + video_Y_offset -17, 3, 15); // up
              rect(last_f_hit_X_without_offset + video_X_offset - 2, last_f_hit_Y_without_offset + video_Y_offset +1, 3, 15); // down
              rect(last_f_hit_X_without_offset + video_X_offset - 17, last_f_hit_Y_without_offset + video_Y_offset -2, 15, 3); // left
              rect(last_f_hit_X_without_offset + video_X_offset + 1, last_f_hit_Y_without_offset + video_Y_offset -2, 15, 3); // right
            }
           else
             ellipse(last_f_hit_X_without_offset + video_X_offset, last_f_hit_Y_without_offset + video_Y_offset, f_hit_mark_diameter, f_hit_mark_diameter);
       }  
  
     // draw last hit with offset
     if(last_hit_is_in_screen())
       {
        fill(255, 0, 0, 255); //red
        if(f_projectile_diameter == 0)// for middle evaluation
          {
           rect(last_f_hit_X_without_offset + f_hit_sight_offset_X + video_X_offset - 2, last_f_hit_Y_without_offset + f_hit_sight_offset_Y + video_Y_offset -17, 3, 15); // up
           rect(last_f_hit_X_without_offset + f_hit_sight_offset_X + video_X_offset - 2, last_f_hit_Y_without_offset + f_hit_sight_offset_Y + video_Y_offset +1, 3, 15); // down
           rect(last_f_hit_X_without_offset + f_hit_sight_offset_X + video_X_offset - 17, last_f_hit_Y_without_offset + f_hit_sight_offset_Y + video_Y_offset -2, 15, 3); // left
           rect(last_f_hit_X_without_offset + f_hit_sight_offset_X + video_X_offset + 1, last_f_hit_Y_without_offset + f_hit_sight_offset_Y + video_Y_offset -2, 15, 3); // right
          }
        else
          ellipse(last_f_hit_X_without_offset + f_hit_sight_offset_X + video_X_offset, last_f_hit_Y_without_offset + f_hit_sight_offset_Y + video_Y_offset, f_hit_mark_diameter, f_hit_mark_diameter);
       }
  };
};


void draw_stats()
{
  x_position = 10;
  y_position = video_height + video_Y_offset;
  fill(backround_color);  
  if(video_height == 480)
    {
    rect(x_position, y_position, 640, 50); //640*480
    }
  else
    {
    rect(x_position, y_position, 800, 50);  //800*600
    }
  textSize(40);
  fill(0, 170, 30, 255);
  //text(s_Points, x_position, y_position, 250, 300);
  text(s_Points + s_colon_with_space, x_position, y_position, 250, 300);
  text(s_Hits + s_colon_with_space, x_position + 220, y_position, 250, 300);
  text(s_Total + s_colon_with_space, x_position + 410, y_position, 250, 300);
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

void draw_conditions()
{
  x_position = video_width + 20;
  y_position = 60;
  fill(backround_color);  
  rect(x_position, y_position, 250, 175); //640*480
  fill(0, 0, 0, 255);
  textSize(16);
  
  text(s_Shooter + s_colon_with_space, x_position, y_position, 200, 20);
  text(s_Shooter_name, x_position + 100, y_position, 200, 20);

  text(s_Weapon + s_colon_with_space, x_position, y_position +25, 200, 20);
  text(s_weapon_name, x_position + 100, y_position +25, 200, 20);
  
  text(s_Caliber + s_colon_with_space, x_position, y_position +50, 200, 20);
  text(s_projectile_diameter + " " +s_Caliber_units, x_position + 100, y_position +50, 200, 20);

  text(s_Target + s_colon_with_space, x_position, y_position +75, 200, 20);
  text(target_name, x_position + 100, y_position +75, 200, 20);
  
  text(s_Distance + s_colon_with_space, x_position, y_position +100, 200, 20);
  text(f_simulated_distance + " " + s_distance_units, x_position + 100, y_position +100, 200, 20);
  
  
    
  text(s_Time + s_colon_with_space, x_position, y_position +125, 200, 20);
  if(b_time_limit)
    {
      text(s_shooting_time_total, x_position + 100, y_position +125, 200, 20);
    }
  else
    {
      text(" -- ", x_position + 100, y_position +125, 200, 20);
    };
  
  text(s_Rounds + s_colon_with_space, x_position, y_position +150, 200, 20);
  if(b_hit_limit)
    {
      text(i_Rounds + " " + s_rounds_hits, x_position + 100, y_position +150, 200, 20);
    }
  else
    {
      text(" -- ", x_position + 100, y_position +150, 200, 20);
    };

  
  // time + 150
  

}


void draw_sensitivity()
{
  if(b_Configure == true)
  {
  //x_position = video_width +video_X_offset - 250 ;
  //y_position = video_height + video_Y_offset - 25;
  x_position = video_X_offset + 10;
  y_position = video_Y_offset + 8;
  fill(255, 0, 0, 255);
  textSize(24);
  text(s_Sensitivity  + s_colon_with_space  + nf(i_sensitivity,2) , x_position, y_position, 250, 300);
  y_position += 30;
  text(s_Amplify  + s_colon_with_space  + int(f_brightness_amplifier * 100) + "%" , x_position, y_position, 250, 300);
  } 
}

