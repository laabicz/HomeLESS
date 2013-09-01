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
  webcam_type = int(c_webcam_type) - 48;
  
  s_video_width = contain[1].substring(14);
  video_width = Integer.valueOf(s_video_width).intValue();
  
  s_video_height = contain[2].substring(15);
  video_height = Integer.valueOf(s_video_height).intValue();
  
  c_sound = contain[3].charAt(8);
  if((int(c_sound) - 48) == 1)
    {
     b_sound = true;
    }
  else
    {
     b_sound = false;
    }
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
