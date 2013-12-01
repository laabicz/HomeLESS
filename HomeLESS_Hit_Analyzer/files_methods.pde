/*
This files_method.pde is part of HomeLESS Hit Analyzer.

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

public String target_name, name_of_target_file;
public int  i_target_type; //target_number,
public int i_number_of_tgt_files = 0, i_simulated_distance = 10, i_real_distance = 5;
String[] s_targets_names;
public boolean b_ha_ini_exist = false, b_english_lng_exist = false;
//dafaluts strings
String[] s_default_ha_ini = {"Webcam = 0","Video width = 640","Video height = 480","Sensitivity = 3","Style = 1","SLH = 1","language = english","Caliber = 4.5","Delay = 3","Duration = 5","Target = airgun_cz.tgt","Scale = 1.00","X correction = 5000","Y correction = 5000", "Time = 120", "Prepare = 5", "Autoshootlog = 1", "Shooter = Mamlas", "Simulated distance = 10", "Real distance = 5"};
String[] s_ha_ini_clear_contain  = {"Webcam = ","Video width = ","Video height = ","Sensitivity = ","Style = ","SLH = ","language = ","Caliber = ","Delay = ","Duration = ","Target = ","Scale = ","X correction = ","Y correction = ", "Time = ", "Prepare = ", "Autoshootlog = ", "Shooter = ", "Simulated distance = ", "Real distance = "};
String[] s_ha_ini_contain  = {"Webcam = ","Video width = ","Video height = ","Sensitivity = ","Style = ","SLH = ","language = ","Caliber = ","Delay = ","Duration = ","Target = ","Scale = ","X correction = ","Y correction = ", "Time = ", "Prepare = ", "Autoshootlog = ", "Shooter = " , "Simulated distance = ", "Real distance = "};
String[] s_shoot_logs = new String[145];
//String[] s_ha_ini_contain = new String[14];
String[] s_default_english_lng = {"Shooter:","Correction:","Caliber:","Infobox:","Duration:","Targets list","New shoot","Select target:","Sound","SLH","Let's fire","Time:","Reset","Export","Points:","Hits:","Total:","Target:","HomeLESS - Hit Analyzer version 1.1b","Found target files:","Save changes", "Shooting style:", "Training", "Sport", "Combat", "Hunting", "Sensitivity: ", "Conditions: ", "Distance: "};
String s_language_file, s_current_language, s_shoot_log_contain ,s_shootlog_full_filename, s_Shootlog_filename;
String s_selected_target_name, s_Sensitivity, s_Conditions, s_Shooter_name, s_Distance;

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
    
    
  /*  
  // any tgt file?
  for (int i = 0; i < files.length; i++)
  {
    File f = files[i];  
    file_name = f.getName();
    isTarget(file_name);
  }  
  */
}


public void load_ha_ini()
{
  convert_time();
  
  String[] contain = loadStrings("ha.ini");
  char c_webcam_type, c_sound , c_style, c_SLH, c_autoshootlog;
  String s_video_width, s_video_height, s_laguage_file, s_caliber, s_delay, s_duration, s_target, s_scale, s_correction_X, s_correction_Y, s_sensitivity;

  //fit
  c_webcam_type = contain[0].charAt(9);
  webcam_type = int(c_webcam_type) - 48;
  
  s_video_width = contain[1].substring(14);
  video_width = Integer.valueOf(s_video_width).intValue();
  
  s_video_height = contain[2].substring(15);
  video_height = Integer.valueOf(s_video_height).intValue();
  
  s_sensitivity = contain[3].substring(14);
  i_sensitivity = Integer.valueOf(s_sensitivity).intValue();
  
  //fit
  c_style = contain[4].charAt(8);
  shooting_style = int(c_style) - 48;
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
  if((int(c_SLH) - 48) == 1)
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
  
  s_selected_target_name = contain[10].substring(9);
  System.out.println(s_selected_target_name);
  
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
  
  c_autoshootlog = contain[16].charAt(15);
  if((int(c_autoshootlog) - 48) == 1)
    {
     b_autoshootlog = true;
    }
  else
    {
     b_autoshootlog = false;
    }
  
  s_Shooter_name = contain[17].substring(10);
  
  i_simulated_distance = Integer.valueOf(contain[18].substring(21)).intValue();
  i_real_distance = Integer.valueOf(contain[19].substring(16)).intValue();
  
  System.out.println("Real distance: " + i_real_distance);
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
  s_Shooter = contain[0];
  s_Correction = contain[1];
  s_Caliber = contain[2];
  s_Infobox = contain[3];
  s_Duration = contain[4];
  s_Targets_list = contain[5];
  s_New_shoot = contain[6];
  s_Target_select = contain[7];
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
  s_Sensitivity = contain[26];
  s_Conditions = contain[27];
  s_Distance = contain[28];
  System.out.println("Basic file lang pack loaded. \n");
};


public void load_target_list_combo()
{

  String path = sketchPath;
  String  file_name;
  ArrayList allFiles = listFilesRecursive(path);
  String[] s_target_file_names = new String[100];

  for (int i = 0; i < allFiles.size(); i++)
  {
    File f = (File) allFiles.get(i);    
    file_name = f.getName();
    if(isTarget(file_name))
      {
      i_number_of_tgt_files++;
      //System.out.println("target number " + i_number_of_tgt_files);
      // list for combo:
      s_target_file_names[i_number_of_tgt_files] = file_name;
      //System.out.println(s_target_file_names[i_number_of_tgt_files]); 

      }
  }
  s_targets_names = new String[i_number_of_tgt_files + 1];
  
  
  for (int j = 1 ; j <= i_number_of_tgt_files; j++)
  {
    //System.out.println("target number " + j);
    //System.out.println(s_target_file_names[j]); 
    s_targets_names[j] = s_target_file_names[j]; 
  }
};


public void load_target_file()
{
  f_targets_diameters = new float[40];
  String full_file_target_name ="targets/";
  full_file_target_name += s_selected_target_name;
  String[] contain = loadStrings(full_file_target_name);
  System.out.println(full_file_target_name);
  
  target_name = contain[0];
  i_target_type = Integer.valueOf(contain[1]).intValue();
  last_target_scale = 0;
  
  //circle target
  if(i_target_type == 0 )
    {
       //circle target i <= 11
       for(int i = 0 ; i<= 11 ; i++ )
        {
         f_targets_diameters[i] = Float.valueOf(contain[i+1]).floatValue();
         //System.out.println("Diameter no.: " + i + " value: " + f_targets_diameters[i] + " field number: " + i);
        }
        //number_of_biggest_diameter = Integer.valueOf(contain[13]).intValue();
        set_number_of_biggest_diameter();
        target_diameters_center_X = (video_width / 2) - 1;
        target_diameters_center_Y = (video_height / 2) - 1;
    }
 
 //square circle target
  if(i_target_type == 1 )
    {
       //circle target i <= 11
       for(int i = 0 ; i<= 11 ; i++ )
        {
         f_targets_diameters[i] = Float.valueOf(contain[i+1]).floatValue();
         //System.out.println("Diameter no.: " + i + " value: " + f_targets_diameters[i] + " field number: " + i);
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
  else if(i_target_type == 2 )
    {
      for(int i = 0 ; i<= 11 ; i++ )
      {
       f_targets_diameters[i] = Float.valueOf(contain[i+1]).floatValue();
       //System.out.println("Diameter no.: " + i + " value: " + target_diameters[i] + " field number: " + i);
      }
    }
    
  if(i_target_type == 5 )
    {
       //circle target i <= 11
       for(int i = 0 ; i<= 11 ; i++ )
        {
         f_targets_diameters[i] = Float.valueOf(contain[i+1]).floatValue();
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
  byte byte_style = 1, byte_SLH = 1, byte_autoshootlog = 1;


  s_ha_ini_contain[0] = "Webcam = ";
  s_ha_ini_contain[1] = "Video width = ";
  s_ha_ini_contain[2] = "Video height = ";
  s_ha_ini_contain[3] = "Sensitivity = ";
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
  s_ha_ini_contain[16] = "Autoshootlog = ";
  s_ha_ini_contain[17] = "Shooter = ";
  s_ha_ini_contain[18] = "Simulated distance = ";
  s_ha_ini_contain[19] = "Real Distance = ";

  //s_ha_ini_contain = s_ha_ini_clear_contain;
    
  if(b_show_last_hit)
    {
     byte_SLH = 1;
    }
  else
    {
     byte_SLH = 0;
    };   

  if(b_autoshootlog)
  {
     byte_autoshootlog = 1;
  }
  else
  {
     byte_autoshootlog = 0;
  };


  s_ha_ini_contain[0] += webcam_type;
  s_ha_ini_contain[1] += video_width;
  s_ha_ini_contain[2] += video_height;
  s_ha_ini_contain[3] += i_sensitivity;
  s_ha_ini_contain[4] += shooting_style;
  s_ha_ini_contain[5] += byte_SLH;
  s_ha_ini_contain[6] += s_current_language;
  s_ha_ini_contain[7] += projectile_diameter;
  s_ha_ini_contain[8] += i_delay;
  s_ha_ini_contain[9] += duration;
  s_ha_ini_contain[10] += s_selected_target_name;
  s_ha_ini_contain[11] += target_scale;
  s_ha_ini_contain[12] += (correction_X + 5000);
  s_ha_ini_contain[13] += (correction_Y + 5000);
  s_ha_ini_contain[14] += f_shooting_time;
  s_ha_ini_contain[15] += i_shooting_prepare;
  s_ha_ini_contain[16] += byte_autoshootlog;
  s_ha_ini_contain[17] += s_Shooter_name;
  s_ha_ini_contain[18] += i_simulated_distance;
  s_ha_ini_contain[19] += i_real_distance;
  
  saveStrings("ha.ini", s_ha_ini_contain);
  System.out.println("Changes in configuration has been saved into ha.ini file.");

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
  String s_current_year, s_current_year_full, s_current_month, s_current_day, s_current_hour, s_current_minute;
  String s_current_shooting_style, s_total_shooting_time_hh_mm, s_average_points;
  float f_average_points = 0;
  int i_line_offset = 0;
  
  s_current_year = String.valueOf(year() - 2000);
  s_current_year_full = String.valueOf(year());
  s_current_month = String.valueOf(nf(month(),2));
  s_current_day = String.valueOf(nf(day(),2));
  s_current_hour = String.valueOf(nf(hour(),2));
  s_current_minute = String.valueOf(nf(minute(),2));
  
  f_shooting_time = i_time_of_shooting_s;
  float f_seconds = f_shooting_time % 60;
  float f_minutes = (f_shooting_time - f_seconds) / 60 ;
  String s_seconds = String.valueOf(nf((int)f_seconds,2));
  String s_minutes = String.valueOf(nf((int)f_minutes,2));
  //System.out.println("Minutes: " + s_minutes);
  //System.out.println("Seconds: " + s_seconds); 
  s_total_shooting_time_hh_mm = s_minutes + ":" + s_seconds;
  
  
  f_average_points = (float(hit_points_sum)/ float(hit_counter));
  s_average_points = nf(f_average_points,2,2);
  // replace "," by "."
  s_average_points = s_average_points.substring(0,2) + "." + s_average_points.substring(3);
  
  //if(b_training_style) for disable shootlog
  s_current_shooting_style = "Training";
  if(b_hunting_style)
  s_current_shooting_style = "Hunting";
  if(b_combat_style)
  s_current_shooting_style = "Combat";
  if(b_sport_style)
  s_current_shooting_style = "Sport";
  
  //YYMMDDHHMM_PPP_CC_ShooterName
  s_Shootlog_filename =   s_current_year + s_current_month + s_current_day + s_current_hour + s_current_minute;
  s_Shootlog_filename += "_" + String.valueOf(nf(hit_points_sum,3));
  s_Shootlog_filename += "_" + String.valueOf(nf(hit_counter,2)); 
  s_Shootlog_filename += "_" + txtShootlog_filename.getText() + ".slg";


  s_shoot_log_contain = txtShootLog.getText(); 
  s_shootlog_full_filename = "shootlogs/";
  s_shootlog_full_filename += s_Shootlog_filename;
  
  s_shoot_logs[0] = "Date: " + s_current_day + "." + s_current_month + "." + s_current_year_full;
  s_shoot_logs[1] = "Hour: " + s_current_hour + ":" + s_current_minute;
  s_shoot_logs[2] = "Name: " + txtShootlog_filename.getText();
  s_shoot_logs[3] = "Total: " + String.valueOf(hit_points_sum); 
  s_shoot_logs[4] = "Hits: " + String.valueOf(hit_counter);
  s_shoot_logs[5] = "Average: " + s_average_points;
  s_shoot_logs[6] = "Time: " + s_total_shooting_time_hh_mm;
  s_shoot_logs[7] = "Caliber: " + String.valueOf(txt_projectile_diameter); 
  
  s_shoot_logs[7] += " mm"; //metric units
  
  s_shoot_logs[8] = "Target name: " + target_name;
  s_shoot_logs[9] = "Simulated distance: " + String.valueOf(i_simulated_distance) + " meters"; 
  s_shoot_logs[10] = "Real distance: " + String.valueOf(i_real_distance) + " meters ";
  s_shoot_logs[11] = "Style: " + s_current_shooting_style;
  s_shoot_logs[12] = "";
  s_shoot_logs[13] = "";
  s_shoot_logs[14] = "";
  // free position
  s_shoot_logs[15] = "";
  s_shoot_logs[16] = "";
  s_shoot_logs[17] = "";
  s_shoot_logs[18] = s_About;
  s_shoot_logs[19] = "Shootlog version: 1";
  s_shoot_logs[20] = "";
  
  //s_log_logs[] from System_methods -> write_to_shoot_log()
  
  s_shoot_logs[hit_counter + 21] = "";
  s_shoot_logs[hit_counter + 22] = "Target file: " + s_selected_target_name;
  s_shoot_logs[hit_counter + 23] = "Target type: " + String.valueOf(i_target_type);
  
  if(i_target_type == 0) //circle target
   {
    for(int number_of_diameter = 1; number_of_diameter < 11; number_of_diameter++)
      {
        s_shoot_logs[hit_counter + 23 + number_of_diameter] = nf((number_of_diameter),2) + ":" +String.valueOf(f_targets_diameters[number_of_diameter] * f_diameter_scale);
      };
    s_shoot_logs[hit_counter + 34] = "CX:" + String.valueOf(target_diameters_center_X + correction_X);
    s_shoot_logs[hit_counter + 35] = "CY:" + String.valueOf(target_diameters_center_Y + correction_Y);
    s_shoot_logs[hit_counter + 36] = "MD:" + String.valueOf(number_of_black_diameter); //mark diameter (black dia.)
    i_line_offset = 10;
   };
  
  if(i_target_type == 1) //square circle target
   {
    for(int number_of_diameter = 1; number_of_diameter < 11; number_of_diameter++)
      {
        s_shoot_logs[hit_counter + 23 + number_of_diameter] = nf((number_of_diameter),2) + ":" + String.valueOf(f_targets_diameters[number_of_diameter] * f_diameter_scale);
      };
    s_shoot_logs[hit_counter + 34] = "CX:" + String.valueOf(target_diameters_center_X + video_X_offset + correction_X);
    s_shoot_logs[hit_counter + 35] = "CY:" + String.valueOf(target_diameters_center_Y + video_Y_offset + correction_Y);
    s_shoot_logs[hit_counter + 36] = "A1X:" + String.valueOf(A1X + correction_X);
    s_shoot_logs[hit_counter + 37] = "A1Y:" + String.valueOf(A1Y + correction_Y);
    s_shoot_logs[hit_counter + 38] = "A2X:" + String.valueOf(A2X);
    s_shoot_logs[hit_counter + 39] = "A2Y:" + String.valueOf(A2Y);
    s_shoot_logs[hit_counter + 40] = "B1X:" + String.valueOf(B1X + correction_X);
    s_shoot_logs[hit_counter + 41] = "B1Y:" + String.valueOf(B1Y + correction_Y);
    s_shoot_logs[hit_counter + 42] = "B2X:" + String.valueOf(B2X);
    s_shoot_logs[hit_counter + 43] = "B2Y:" + String.valueOf(B2Y);
    s_shoot_logs[hit_counter + 44] = "MD:" + String.valueOf(number_of_black_diameter);
    i_line_offset = 18;

   }
  
  s_shoot_logs[hit_counter + 27 + i_line_offset] = "PS: " + String.valueOf(f_diameter_scale); //pixel scale
  //s_shoot_logs[hit_counter + 28] = "Pixel scale2: " + String.valueOf(f_square_scale);  //- same as the f_diameter_scale
  
  //X: xxxx Y: yyyy P: pp T: tttt

  saveStrings(s_shootlog_full_filename, s_shoot_logs);
  
  //System.out.println("Shootlog has been exported into file: " + s_shootlog_full_filename );
  
  x_position = video_X_offset +10;
  y_position = video_height + video_Y_offset - 60;
  fill(255, 0, 0, 255);
  textSize(24);
  text("Shootlog has been exported into file:", x_position, y_position, 600, 30);
  text(s_Shootlog_filename, x_position, y_position + 25, 600, 30);
  // clearing shootlog
  
  for(int index = 0; index < 145; index++)
    {
      s_shoot_logs[index] = "";
    }
  
}






// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir)
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
File[] listFiles(String dir)
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
ArrayList listFilesRecursive(String dir)
{
   ArrayList fileList = new ArrayList(); 
   recurseDir(fileList,dir);
   return fileList;
}

// Recursive function to traverse subdirectories
void recurseDir(ArrayList a, String dir)
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
