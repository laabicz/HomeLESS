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
along with HomeLESS Hit Analyzer.  If not, see <http://www.gnu.org/licenses/>.
*/

public String target_name, name_of_target_file;
public int  i_target_type, i_selected_target_number = 0;
public int i_number_of_tgt_files = 0, i_real_distance = 5;

public String s_current_year, s_current_year_full, s_current_month, s_current_day, s_current_hour, s_current_minute;
public String s_current_shooting_style, s_total_shooting_time_hh_mm, s_average_points;

public boolean b_distance_units_are_metric = true;





String[] s_targets_names;  //old
//public String[] s_targets_names = new String[101]; // new



public boolean b_ha_ini_exist = false, b_english_lng_exist = false, b_hip_ini_exist = false;

String[] s_shoot_logs = new String[145];


String s_language_file, s_current_language, s_shoot_log_contain ,s_shootlog_full_filename, s_Shootlog_filename;
public String s_colon_with_space = ": ", s_selected_target_name;
//translationable variables :)
public String s_Sensitivity, s_Conditions, s_Shooter_name, s_Distance, s_Simulated_distance, s_Real_distance, s_Weapon;
public String s_Date, s_Hour, s_Average, s_Target_name;
public String s_Shootlog_version, s_Target_file, s_Target_type;


public void check_basic_files()
{

  String patch = sketchPath;
  String  all_files_names;
  ArrayList all_Files = listFilesRecursive(patch);
  //System.out.println("s_selected_target_name " + s_selected_target_name);
  //find and count all tgt files and get their names
  for (int i = 0; i < all_Files.size(); i++)
  {
    File f = (File) all_Files.get(i);    
    all_files_names = f.getName();
    is_english_lng_file(all_files_names);
    is_ha_ini_file(all_files_names);
    is_hip_ini_file(all_files_names);
    //System.out.println("File2: " +all_files_names);
  }  
  
  
  // ha.ini exist?   
  if(b_ha_ini_exist == false)
    {
      System.out.println("\nWARNING: File \"ha.ini\" not found.");
      save_file_default_ha_ini();
      save_file_default_weapon_gun();
      save_file_default_air_rifle_cz_tgt();
    };
  
  
  // english.lng exist?   
  if(b_english_lng_exist == false)
    {
      System.out.println("\nWARNING: File \"english.lng\" not found.");
      save_file_default_english_lng();
    };
   
  if(b_hip_ini_exist == false)
    { 
      System.out.println("\nWARNING: File \"hip.ini\" not found.");
      save_file_default_hip_ini();
    };
}


public void load_ha_ini()
{
  convert_time();

  //** lines definitions **
  //webcam settings
  int i_webcam_line = 1;
  int i_rear_camera_line = 2;
  int i_video_width_line = 3;
  int i_video_height_line = 4;
  int i_sensitivity_line = 5;
  //general settings
  int i_shooter_name_line = 8;
  int i_weapon_file_line = 9; 
  int i_language_line = 10;
  int i_autoshotlog_line = 11;
  int i_sound_line = 12;
  
  //shooting settings
  int i_rounds_line = 15; 
  int i_shooting_time_line = 16;
  int i_time_limit_line = 17;
  int i_countdown_line = 18;
  int i_hit_limit_line = 19;
  int i_SLH_line = 20;
  int i_shooting_prepare_counter_line = 21;

  //target properties
  int i_target_file_line = 24;
  int i_target_scale_line = 25;
  int i_target_correction_X_line = 26;
  int i_target_correction_Y_line = 27;
  int i_simulated_distance_line = 28;
  int i_real_distance_line = 29;
  int i_metric_distance_line = 30;
  
  
  String[] ha_ini_file_contain = loadStrings("ha.ini");
  String[] ha_ini_file_contain_parts;
  String s_laguage_file, s_caliber, s_delay, s_duration, s_rounds, s_target, s_scale, s_correction_X, s_correction_Y, s_sensitivity;
  //Webcam settings:
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_webcam_line], "=");
  webcam_type = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue();
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_video_width_line], "=");
  video_width = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue();
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_video_height_line], "=");
  video_height = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue();
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_sensitivity_line], "=");
  i_sensitivity = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue();
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_rear_camera_line], "=");
  if(Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue() == 1)
    {
    b_invert_hit_X = true;
    };
  
  //** Shooting settings **
  
  //Rounds
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_rounds_line], "=");
  i_Rounds = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue();
  
  //Shooting time
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_shooting_time_line], "=");
  //f_shooting_time = Float.valueOf(ha_ini_file_contain_parts[1].trim()).floatValue();
  i_time_of_shooting_total = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue();
  i_time_of_shooting_countdown = i_time_of_shooting_total;
  i_time_of_shooting_actual = i_time_of_shooting_total;

  
  
  //Time limit trigger
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_time_limit_line], "=");
  if( Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue() == 1)
      {
        b_time_limit = true;
      };
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_countdown_line], "=");
  if( Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue() == 1)
      {
        b_show_time_as_countdown = true;
      };      
  
  convert_time();
  //Hit limit trigger
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_hit_limit_line], "=");
    if( Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue() == 1)
      {
        b_hit_limit = true;
      };
  
  //SLH trigger
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_SLH_line], "=");
  if( Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue() == 1)
    { 
    b_show_last_hit = true;
    };
    
  //Prepare time
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_shooting_prepare_counter_line], "=");
  i_shooting_prepare = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue();
  if(i_shooting_prepare < 1)
  {
    System.out.println("\nWARNING: Shooting prepare counter set too low, new value is set to 1.");
    i_shooting_prepare = 1;
  }
  i_shooting_prepare_actual = i_shooting_prepare;
  
  
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_language_line], "=");
  s_current_language = ha_ini_file_contain_parts[1].trim();
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_weapon_file_line], "=");
  s_selected_weapon_file = ha_ini_file_contain_parts[1].trim();
  
 
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_sound_line], "=");
  
  if((Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue()) > 0)
  {
    b_sound_enabled = true;
    //System.out.println("Sound enabled");
  }
  
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_target_file_line], "=");
  s_selected_target_name = ha_ini_file_contain_parts[1].trim();
  
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_target_scale_line], "=");
  target_scale = Float.valueOf(ha_ini_file_contain_parts[1].trim()).floatValue();
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_target_correction_X_line], "=");
  correction_X = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue() - 5000;
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_target_correction_Y_line], "=");
  correction_Y = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue() - 5000;
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_simulated_distance_line], "=");
  //i_simulated_distance = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue();
  f_simulated_distance = Float.valueOf(ha_ini_file_contain_parts[1].trim()).floatValue();
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_real_distance_line], "=");
  f_real_distance = Float.valueOf(ha_ini_file_contain_parts[1].trim()).floatValue();
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_metric_distance_line], "="); 
  if(Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue() == 0)  //true is default
    {
      b_distance_units_are_metric = false;
      s_distance_units = "yards";
    };
 
  /*
  
  f_real_distance = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue();

  */

  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_autoshotlog_line], "=");
  if( Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue() == 1)
    {
    b_autoshootlog = true;
    //System.out.println("Autoshootlog enabled.");
    };
  
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_shooter_name_line], "=");
  s_Shooter_name = ha_ini_file_contain_parts[1].trim();
  
  
  System.out.println("\nBasic file \"ha.ini\" file loaded.");
  //System.out.println("  - Real distance: " + f_real_distance);
  //System.out.println("  - Simulated distance: " + f_simulated_distance + "\n");
};


public void load_lang_pack()
{
  
  String path = sketchPath;
  String  file_name;
  ArrayList allFiles = listFilesRecursive(path);
  s_language_file = "languages/" + s_current_language + ".lng";
  String[] contain = loadStrings(s_language_file);
  //language pack
  //main
  s_About = contain[0];
  s_Target = contain[1];  
  s_Time = contain[2];
  s_Points = contain[3];
  s_Hits = contain[4];
  s_Total = contain[5];
  s_Shooter = contain[6];
  s_Weapon = contain[7];
  s_Caliber = contain[8];
  s_Distance = contain[9];
  s_Rounds = contain[10];
  s_meters = contain[11];
  s_yards = contain[12];
  s_rounds_hits = contain[13];
  
  //general, contain[14] is clear
  s_Hit_limits = contain[15];
  s_Time_limit = contain[16];
  s_Countdown = contain[17];
  s_Autoshootlog = contain[18];
  s_Sensitivity = contain[19];
  s_Rear_cam = contain[20];
  s_SLH = contain[21];
  
  //target, contain[22] is clear
  s_Select_target_label = contain[23];
  s_Correction_label = contain[24];
  s_Simulated_distance = contain[25];
  s_Real_distance = contain[26];  
  s_Use_metric_system =  contain[27];  
  
  s_distance_units = s_meters;
  if(b_distance_units_are_metric == false)
    {
      s_distance_units = s_yards;
    };
  
  //Weapon
  s_weapon_profile_label = contain[29];
  s_weapon_name_label = contain[30];
  s_Sights_adjustment = contain[31];
  
  //Shootlog
  s_Date = contain[33];
  s_Hour = contain[34];
  s_Average = contain[35];
  s_Target_name = contain[36];
  s_Shootlog_version = contain[37]; 
  s_Target_file = contain[38];
  s_Target_type = contain[39];
  /****Unused***/
  //s_Correction = contain[1];
  //s_Target_select = contain[7];
  //s_Conditions = contain[27];

  System.out.println("\nLang pack file "+ s_current_language + ".lng loaded.");
  //System.out.println("  -"+ s_current_language + ".lng\n");
};

void generate_list_of_targets_files()
{
  String path = sketchPath;
  String  file_name;
  ArrayList allFiles = listFilesRecursive(path);
  String[] s_target_file_names = new String[101];  // maximum 100 targets
  //System.out.println("s_selected_target_name " + s_selected_target_name);
  //find and count all tgt files and get their names
  for (int i = 0; i < allFiles.size(); i++)
  {
    File f = (File) allFiles.get(i);    
    file_name = f.getName();
    if(isTarget(file_name))
      {
      //System.out.println("target number " + i_number_of_tgt_files +" " + file_name);
      s_target_file_names[i_number_of_tgt_files] = file_name;
        //get number for dropList_target_selection default
        if(s_selected_target_name.equals(file_name))
          { 
            i_selected_target_number = i_number_of_tgt_files;
            //System.out.println("selected target number " + i_selected_target_number);
          }
      
      i_number_of_tgt_files++;
      }
  
  }
  
  if(i_number_of_tgt_files == 0)
    {
      System.out.println("\nWARNING: No \"tgt\" file found.\n");
      save_file_default_air_rifle_cz_tgt();
      s_selected_target_name = "air_rifle_cz.tgt";
      save_file_ha_ini();
    }
  
  //store targets name into new string
  s_targets_names = new String[i_number_of_tgt_files];
  for (int j = 0 ; j < i_number_of_tgt_files; j++)
    {
      s_targets_names[j] = s_target_file_names[j]; 
    }
  
  saveStrings("targets/list_of_targets", s_targets_names);
  System.out.println("\nList of targets created."); 
  
}


public void load_target_file()
{
  f_targets_diameters = new float[40];
  String full_file_target_name ="targets/";
  full_file_target_name += s_selected_target_name;
  String[] contain = loadStrings(full_file_target_name);
  //System.out.println(full_file_target_name);
  
  target_name = contain[0];
  i_target_type = Integer.valueOf(contain[1]).intValue();
  
  b_monoscope_synchronization_enabled = false;
  if(i_target_type == 4)
    {
      b_monoscope_synchronization_enabled = true;
      b_hit_limit = false;
      b_time_limit = false;
      convert_time();
    }
  last_target_scale = 0;
  
  //circle target
  if((i_target_type == 0) || (i_target_type == 2) )
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
 
 //square circle target, monoscope
  if((i_target_type == 1) || (i_target_type == 3) || (i_target_type == 4))
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
        if(b_monoscope_synchronization_enabled)
          {
            f_hit_remap_range_min_X = A1X;
            f_hit_remap_range_min_Y = A1Y;
            f_hit_remap_range_max_X = B2X;
            f_hit_remap_range_max_Y = B2Y + A2Y;
          }       
    }

  analyze_the_target();
}

void generate_list_of_gun_files()
{
  String path = sketchPath;
  String  file_name;
  ArrayList allFiles = listFilesRecursive(path);
  String[] s_gun_file_names = new String[101];  // maximum 100 weapons
  String[] s_weapons_list;
  int i_internal_counter = 0;
  int i_number_of_gun_files = 0;
  //System.out.println("s_selected_target_name " + s_selected_target_name);
  //find and count all tgt files and get their names
  
  for (int i = 0; i < allFiles.size(); i++)
  {
    File f = (File) allFiles.get(i);    
    file_name = f.getName();
    if(is_gun_file(file_name))
      {
      s_gun_file_names[i_number_of_gun_files] = file_name;
      i_number_of_gun_files++;
      }
  }

  if(i_number_of_gun_files == 0)
   {
     System.out.println("\nWarning: No \"gun\" file found.");
     save_file_default_weapon_gun();
     i_number_of_selected_weapon = 0;
     i_number_of_gun_files = 1;
     s_selected_weapon_file = "default_weapon.gun";
     save_file_ha_ini();
   }
  
  
  //store weapons name into new string
  s_weapons_list = new String[i_number_of_gun_files];
  for (int j = 0 ; j < i_number_of_gun_files; j++)
  {
    s_weapons_list[j] = s_gun_file_names[j];
    
    if(s_selected_weapon_file.equals(s_weapons_list[j]))
        { 
          i_number_of_selected_weapon = j;
          //System.out.println("i_number_of_selected_weapon " + i_number_of_selected_weapon);
        }
  }
  
  saveStrings("weapons/list_of_weapons", s_weapons_list);
  System.out.println("\nList of weapons created.");
  
  
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

public boolean is_gun_file(String name)
{
  if(name.endsWith("gun") == true)
  {
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

public boolean is_hip_ini_file(String name)
{
 if(name.equals("hip.ini"))
  {
    b_hip_ini_exist = true;
    return true;
  } 
  else
  {
   return false; 
  }
}



public void save_file_ha_ini()
{
  String[] s_ha_ini_contain = new String[31];
  byte byte_rear_cam = 0, byte_autoshootlog = 0, byte_time_limit = 0, byte_SLH = 0, byte_metric_distance = 0, byte_hit_limit = 0, byte_countdown = 0;
  String s_sound_enabled = "0";
  
  if(b_invert_hit_X)
    {
      byte_rear_cam = 1;
    };
  
  if(b_show_last_hit)
    {
     byte_SLH = 1;
    };

  if(b_autoshootlog)
    {
     byte_autoshootlog = 1;
    };
  
  if(b_time_limit)
    {
      byte_time_limit = 1;
    };
    
  if(b_hit_limit)
    {
      byte_hit_limit = 1;
    }  
    
  if(b_distance_units_are_metric)
    {  
      byte_metric_distance = 1;
    };

  if(b_show_time_as_countdown)
  {
    byte_countdown = 1;
  };  
    
  if(b_sound_enabled)
  {
    s_sound_enabled = "1"; //"0" by default
  }
  
  
  s_ha_ini_contain[0] = "** Webcam settings **";
  s_ha_ini_contain[1] = "Webcam = " + webcam_type;
  s_ha_ini_contain[2] = "Rear cam = " + byte_rear_cam;
  s_ha_ini_contain[3] = "Video width = " + video_width;
  s_ha_ini_contain[4] = "Video height = " + video_height;
  s_ha_ini_contain[5] = "Sensitivity = " + i_sensitivity;
  s_ha_ini_contain[6] = "";
  s_ha_ini_contain[7] = "** General settings **";
  s_ha_ini_contain[8] = "Shooter = " + s_Shooter_name;
  s_ha_ini_contain[9] = "Weapon = " + s_selected_weapon_file;
  s_ha_ini_contain[10] = "Language = " + s_current_language;
  s_ha_ini_contain[11] = "Autoshootlog = " + byte_autoshootlog;
  s_ha_ini_contain[12] = "Sound = " + s_sound_enabled;
  s_ha_ini_contain[13] = "";
  s_ha_ini_contain[14] = "** Shooting settings **";
  s_ha_ini_contain[15] = "Rounds = " + i_Rounds;
  s_ha_ini_contain[16] = "Time = " + i_time_of_shooting_total;
  s_ha_ini_contain[17] = "Time limit = " + byte_time_limit;
  s_ha_ini_contain[18] = "Countdown = " + byte_countdown;
  s_ha_ini_contain[19] = "Hit limit = " + byte_hit_limit;
  s_ha_ini_contain[20] = "SLH = " + byte_SLH;
  s_ha_ini_contain[21] = "Prepare = " + i_shooting_prepare;
  s_ha_ini_contain[22] = "";
  s_ha_ini_contain[23] = "** Target settings **";
  s_ha_ini_contain[24] = "Target = " + s_selected_target_name;
  s_ha_ini_contain[25] = "Scale = " + target_scale;
  s_ha_ini_contain[26] = "X correction = " + (correction_X + 5000);
  s_ha_ini_contain[27] = "Y correction = " + (correction_Y + 5000);
  s_ha_ini_contain[28] = "Simulated distance = " + f_simulated_distance;
  s_ha_ini_contain[29] = "Real distance = " + f_real_distance;
  s_ha_ini_contain[30] = "Metric distance = " + byte_metric_distance;

  saveStrings("ha.ini", s_ha_ini_contain);
  System.out.println("\nChanges in configuration has been saved into ha.ini file.\n");
};




public void save_file_default_ha_ini()
{
  String[] s_default_ha_ini = {"** Webcam settings **", "Webcam = 6", "Rear cam = 0", "Video width = 640", "Video height = 480", "Sensitivity = 1", "", "** General settings **", "Shooter = Mamlas", "Weapon = default_weapon.gun", "Language = english", "Autoshootlog = 1", "Sound = 1","", "** Shooting settings **", "Rounds = 10", "Time = 30", "Time limit = 1","Countdown = 1" ,"Hit limit = 1", "SLH = 1", "Prepare = 3", "", "** Target settings **", "Target = air_rifle_cz.tgt", "Scale = 1", "X correction = 5000", "Y correction = 5000", "Simulated distance = 10", "Real distance = 5", "Metric distance = 1"};
  saveStrings("ha.ini", s_default_ha_ini);
  System.out.println("\nFile \"ha.ini\" has been created with default settings.");
}

public void save_file_default_english_lng()
{
  String[] s_default_english_lng = {"HomeLESS - Hit Analyzer version 1.2a", "Target", "Time", "Points", "Hits", "Total", "Shooter", "Weapon", "Caliber", "Distance", "Rounds", "meters", "yards", "hits", "** General settings **", "Hits limit", "Time limit", "Countdown", "Autoshootlog", "Sensitivity", "Rear cam", "Show last hit", "** Target setttings **", "Target selection", "Correction", "Simulated distance", "Real distance", "Use metric system", "** Weapon settings **", "Profile", "Name", "Sight adjustment", "** Shootlog **", "Date", "Hour", "Average", "Target name", "Shootlog version: 2", "Target file", "Target type"};
  saveStrings("languages/english.lng", s_default_english_lng);
  System.out.println("\nDefault file \"./languages/english.lng\" has been created!");
}


public void save_file_default_air_rifle_cz_tgt()
{
  String[] s_default_air_rifle_cz_tgt = {"Air Rifle CZ", "0", "120", "108", "96", "84", "72", "60", "48", "36", "24", "12", "7"};
  saveStrings("targets/air_rifle_cz.tgt", s_default_air_rifle_cz_tgt);
  System.out.println("\nDefault file \"./targets/air_rifle_cz.tgt\" has been created!");
}

public void save_file_default_weapon_gun()
{
  String[] s_default_weapon_gun = {"BFG-9000", "0", "mm", "300", "5000", "5000"};
  saveStrings("weapons/default_weapon.gun", s_default_weapon_gun);
  System.out.println("Default file \"./weapons/default_weapon.gun\" has been created!\n");  
}

public void save_file_default_hip_ini()
{
  String[] s_default_hip_ini = {"** General **", "HIP enable = 0", "", "** Source **", "IP addres = 127.0.0.1", "Port = 56789", "SID = 00000001", "", "** Destination **", "IP addres = 127.0.0.1", "Port = 58618", "","** Others **", "Invert X = 0", "Invert Y = 0"};
  saveStrings("hip.ini", s_default_hip_ini);
  System.out.println("!File \"hip.ini\" has been created with default settings.");
}


public void export_file_shoot_log()
{
  if(b_autoshootlog_written == false)
    {
      float f_average_points = 0;
      float f_pixel_scale = 1; //px/mm, PS:3.14 PS mean 3.14 pixels to 1 milimeter
      int i_line_offset = 0;
      int i_seconds_of_last_hit, i_minutes_of_last_hit;
      String s_seconds_of_last_hit, s_minutes_of_last_hit;
      
      s_current_year = String.valueOf(year() - 2000);
      s_current_year_full = String.valueOf(year());
      s_current_month = String.valueOf(nf(month(),2));
      s_current_day = String.valueOf(nf(day(),2));
      s_current_hour = String.valueOf(nf(hour(),2));
      s_current_minute = String.valueOf(nf(minute(),2));
      
      if(b_hit_limit == true  && (hit_counter != 0))
        {
          f_average_points = (float(hit_points_sum)/ float(hit_counter));
        }
      else
        {
          f_average_points = 0.0;
        }
      
      s_average_points = nf(f_average_points,2,2);
      // replace "," by "."
      s_average_points = s_average_points.substring(0,2) + "." + s_average_points.substring(3);

      //YYMMDDHHMM_PPP_CC_ShooterName
      s_Shootlog_filename =   s_current_year + s_current_month + s_current_day + s_current_hour + s_current_minute;
      s_Shootlog_filename += "_" + String.valueOf(nf(hit_points_sum,3));
      s_Shootlog_filename += "_" + String.valueOf(nf(hit_counter,2)); 
      s_Shootlog_filename += "_" + s_Shooter_name + ".slg";
    
      //s_shoot_log_contain = txtShootLog.getText(); 
      s_shootlog_full_filename = "shootlogs/";
      s_shootlog_full_filename += s_Shootlog_filename;
      
      s_shoot_logs[0] = s_Date + s_colon_with_space + s_current_year_full + "-" + s_current_month + "-" + s_current_day;
      s_shoot_logs[1] = s_Hour + s_colon_with_space + s_current_hour + ":" + s_current_minute;
      s_shoot_logs[2] = s_Shooter + s_colon_with_space + s_Shooter_name;
      s_shoot_logs[3] = s_Total + s_colon_with_space + String.valueOf(hit_points_sum); 
      s_shoot_logs[4] = s_Hits + s_colon_with_space + String.valueOf(hit_counter);
      s_shoot_logs[5] = s_Average + s_colon_with_space + s_average_points;
          
          
          
      i_seconds_of_last_hit = (int)(f_time_of_hit_detection_relative % 60);
      i_minutes_of_last_hit = ((int)f_time_of_hit_detection_relative - i_seconds_of_last_hit) / 60 ;
      s_seconds_of_last_hit = String.valueOf(nf(i_seconds_of_last_hit,2));
      s_minutes_of_last_hit = String.valueOf(nf(i_minutes_of_last_hit,2));
      s_shoot_logs[6] = s_Time + s_colon_with_space + s_minutes_of_last_hit + ":" + s_seconds_of_last_hit;  //total time of shooting
      s_shoot_logs[7] = s_Weapon + s_colon_with_space + s_weapon_name; 
      s_shoot_logs[8] = s_Caliber + s_colon_with_space + s_projectile_diameter + s_Caliber_units;
      s_shoot_logs[9] = s_Target_name + s_colon_with_space + target_name;
      s_shoot_logs[10] = s_Simulated_distance + s_colon_with_space + String.valueOf(f_simulated_distance) + " " + s_distance_units; 
      s_shoot_logs[11] = s_Real_distance + s_colon_with_space + String.valueOf(f_real_distance) + " " + s_distance_units;
      s_shoot_logs[12] = s_Time_limit + s_colon_with_space + s_minutes_total + ":" + s_seconds_total;
      if(b_hit_limit)
        {
          s_shoot_logs[13] = s_Hit_limits + s_colon_with_space + i_Rounds;
        }
      else
        {
          s_shoot_logs[13] = s_Hit_limits + s_colon_with_space + "--";
        };
      s_shoot_logs[14] = "";
      // free position
      s_shoot_logs[15] = "";
      s_shoot_logs[16] = "";
      s_shoot_logs[17] = "";
      s_shoot_logs[18] = s_About;
      s_shoot_logs[19] = s_Shootlog_version;
      s_shoot_logs[20] = "";
      
      //s_log_logs[] from System_methods -> write_to_shoot_log()
      
      s_shoot_logs[hit_counter + 21] = "";

      s_shoot_logs[hit_counter + 22] = s_Target_file + s_colon_with_space + s_selected_target_name;
      s_shoot_logs[hit_counter + 23] = s_Target_type + s_colon_with_space + String.valueOf(i_target_type);
      
      if((i_target_type == 0) || (i_target_type == 2)) //circle target
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
      
      if(i_target_type == 1 || (i_target_type == 3) || (i_target_type == 4)) //square circle target
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
      
      
      f_pixel_scale = f_diameter_scale;
      
      if(b_projectile_diameter_is_metric == false)
      {
        f_pixel_scale = f_pixel_scale / 25.4;
      }
      
      if(b_projectile_diameter_is_metric != b_target_diameter_is_metric)   //target and caliber are not at same unit
        {
         if(b_projectile_diameter_is_metric == false)  //caliber is in inches
            {
             f_pixel_scale = f_pixel_scale * 25.4;     
            }
        
         if(b_target_diameter_is_metric == false)  //target is in inches
            {
             f_pixel_scale = f_pixel_scale / 25.4; 
            }
        }        
      s_shoot_logs[hit_counter + 27 + i_line_offset] = "PS: " + String.valueOf(f_pixel_scale); //pixel scale

      
      //X: xxxx Y: yyyy P: pp T: tttt
    
      saveStrings(s_shootlog_full_filename, s_shoot_logs);
      
      System.out.println("!Shootlog has been exported into file: " + s_shootlog_full_filename );
      
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
      b_autoshootlog_written = true;
    }
    else
    {
      System.out.println("\nNo shootlogs data for export.");
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
