/*
This win_weapon_settings.pde is part of HomeLESS Hit Analyzer.

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


// weapon config
GWindow windowWeapon_settings;

GLabel lblWeapon_settings, lblSights_adjustment, lblCaliber;
GLabel lblCaliber_units, lblWeapon_name,lblWeapon_profile;
GTextField txtCaliber, txtWeapon_name;


String s_Weapon_settings = "Weapon settings", s_Sights_adjustment, s_weapon_name_label, s_weapon_profile_label;
String s_projectile_diameter, s_Caliber_units = "";
public float f_hit_sight_offset_X = 0, f_hit_sight_offset_Y = 0, last_f_hit_X_without_offset = -5000, last_f_hit_Y_without_offset = -5000;
public float f_natural_projectile_diameter = 0;
public String s_selected_weapon_file;// = "TAU7_4_5mm.gun";
public String s_weapon_name;
public int i_number_of_selected_weapon = 1;
public boolean b_projectile_diameter_is_metric = true;
int i_new_shooting_start_time_start_value = 3;


public void createwindowWeapon_settings()
{ 
  
  windowWeapon_settings = new GWindow(this, "HA - Weapon settings", 800, 200, 330, 200, false, JAVA2D);
  //windowWeapon_settings = new GWindow(this, "HA - Weapon settings", 800, 200, 330, 200, false, P2D);
  windowWeapon_settings.addDrawHandler(this, "windowWeapon_settings_draw"); 
  
  PApplet win_weapon = windowWeapon_settings.papplet;
  windowWeapon_settings.setActionOnClose(GWindow.CLOSE_WINDOW);
  //windowWeapon_settings.addData(new windowWeapon_settings_data());
  //windowWeapon_settings.addDrawHandler(this, "win_weapon_draw");

  x_position = 10;
  y_position = 20;
  lblWeapon_name = new GLabel(win_weapon, x_position, y_position, 50, 20);
  lblWeapon_name.setText(s_weapon_name_label + s_colon_with_space);
  lblWeapon_name.setOpaque(false);
  lblWeapon_name.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  x_position += 55;
  txtWeapon_name = new GTextField(win_weapon, x_position, y_position, 100, 18);
  txtWeapon_name.setText(s_weapon_name);
  txtWeapon_name.addEventHandler(this, "handle_txtWeapon_name");
  
  x_position = 190;
  y_position = 0;
  lblWeapon_profile = new GLabel(win_weapon, x_position, y_position, 80, 20);
  lblWeapon_profile.setText(s_weapon_profile_label + s_colon_with_space);
  lblWeapon_profile.setOpaque(false);
  lblWeapon_profile.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  y_position += 20;
  dropList_weapon_selection = new GDropList(win_weapon, x_position, y_position, 130, 80, 5);
  dropList_weapon_selection.setItems(loadStrings("weapons/list_of_weapons"), i_number_of_selected_weapon);
  dropList_weapon_selection.addEventHandler(this, "dropList_weapon_selection");
  //load_weapon_file();
  
  x_position = 10;
  y_position = 50;
  lblCaliber = new GLabel(win_weapon, x_position, y_position, 52, 20);
  lblCaliber.setText(s_Caliber + s_colon_with_space);
  lblCaliber.setOpaque(false);
  lblCaliber.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  txtCaliber = new GTextField(win_weapon, x_position + 55, y_position, 50, 18);
  txtCaliber.setText(s_projectile_diameter);
  txtCaliber.addEventHandler(this, "handle_txtCaliber");
  lblCaliber_units = new GLabel(win_weapon, x_position + 80, y_position, 80, 20);
  lblCaliber_units.setText("");
  if(b_projectile_diameter_is_metric)
    {
      lblCaliber_units.setText("mm");
    };
  lblCaliber_units.setOpaque(false);
  
  x_position = 10;
  y_position = 90;
  lblSights_adjustment = new GLabel(win_weapon, x_position, y_position, 180, 20);
  lblSights_adjustment.setText(s_Sights_adjustment + s_colon_with_space);
  lblSights_adjustment.setOpaque(false);
  lblSights_adjustment.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  
  x_position = 60;
  y_position = 150;
  //off over click
  images = new String[] { "graphics/arrow_up_1.png", "graphics/arrow_up_2.png", "graphics/arrow_up_3.png" };
  btnHit_sight_offset_Y_up = new GImageButton(win_weapon, x_position, y_position - 30, images);
  btnHit_sight_offset_Y_up.tag = "Hit_sight_offset_Y_up";
 
  images = new String[]{ "graphics/arrow_left_1.png", "graphics/arrow_left_2.png", "graphics/arrow_left_3.png" };
  btnHit_sight_offset_X_left = new GImageButton(win_weapon, x_position -30, y_position -12, images);
  btnHit_sight_offset_X_left.tag = "Hit_sight_offset_X_left";
  
  images = new String[]{ "graphics/arrow_down_1.png", "graphics/arrow_down_2.png", "graphics/arrow_down_3.png" };
  btnHit_sight_offset_Y_down = new GImageButton(win_weapon, x_position, y_position, images);
  btnHit_sight_offset_Y_down.tag = "Hit_sight_offset_Y_down";
  
  images = new String[]{ "graphics/arrow_right_1.png", "graphics/arrow_right_2.png", "graphics/arrow_right_3.png" };
  btnHit_sight_offset_X_right = new GImageButton(win_weapon, x_position + 30, y_position -12, images);
  btnHit_sight_offset_X_right.tag = "Hit_sight_offset_X_right";
  
  images = new String[]{ "graphics/correction_reset_1.png", "graphics/correction_reset_2.png", "graphics/correction_reset_3.png" };
  btnHit_sight_offset_zero = new GImageButton(win_weapon, x_position + 70, y_position , images);
  btnHit_sight_offset_zero.tag = "Hit_sight_offset_zero";
  
  images = new String[]{ "graphics/sight_autocenter_1.png", "graphics/sight_autocenter_2.png", "graphics/sight_autocenter_3.png" };
  btnHit_sight_autocenter = new GImageButton(win_weapon, x_position + 70, y_position - 30 , images);
  btnHit_sight_autocenter.tag = "Hit_sight_autocenter";
  
  // save weapon settings
  x_position = 220;
  y_position = 150;  
  images = new String[]{ "graphics/weapon_settings_save_1.png", "graphics/weapon_settings_save_2.png", "graphics/weapon_settings_save_3.png" };
  btnSave_gun = new GImageButton(win_weapon, x_position, y_position, images);
  btnSave_gun.tag= "Save_weapon_settings";
}




synchronized public void windowWeapon_settings_draw(GWinApplet appc, GWinData data)
{
  appc.background(backround_color);
  /*
  //for other drawing
  appc.fill(0,0,160);
  appc.noStroke();
  appc.ellipse(appc.width/2, appc.height/2, appc.width/1.2, appc.height/1.2);
  appc.fill(255);
  appc.text("Secondary window", 20, 20);
  */
}


public void handle_txtCaliber(GTextField textfield, GEvent event)
{
  switch(event)
    {
    case CHANGED: 
      b_shortcuts = false;
      break;
    case ENTERED:
      txt_f_projectile_diameter = Float.parseFloat(txtCaliber.getText());
      if(txt_f_projectile_diameter > 20)
      {
        txt_f_projectile_diameter = 20;
        System.out.println("\nWARNING: Caliber value is too high, new value is set to 20 mm.");
        txtCaliber.setText(String.valueOf(txt_f_projectile_diameter));
      }
      f_natural_projectile_diameter = txt_f_projectile_diameter;
      //f_projectile_diameter = txt_f_projectile_diameter;
      s_projectile_diameter = String.valueOf(f_natural_projectile_diameter);
      set_units_of_caliber(f_natural_projectile_diameter);
      set_caliber_dimension();
      lblCaliber_units.setText("");
      if(b_projectile_diameter_is_metric)
        {
          lblCaliber_units.setText("mm");
        };
      break;
    }
};

public void handle_txtWeapon_name(GTextField textfield, GEvent event)
{
  switch(event)
    {
    case CHANGED: 
      b_shortcuts = false;
      break;
    case ENTERED:
      s_weapon_name = txtWeapon_name.getText();
      break;
    }
};



public void dropList_weapon_selection(GDropList source, GEvent event)
{ 
  //println("Selected target: " + dropList_target_selection.getSelectedText());
  s_selected_weapon_file = dropList_weapon_selection.getSelectedText();
  load_weapon_file();
  //txtCaliber.setText(String.valueOf(f_projectile_diameter));
  txtCaliber.setText(s_projectile_diameter);
  txtWeapon_name.setText(s_weapon_name);
  s_Caliber_units = "";
  if(b_projectile_diameter_is_metric)
    {
      //lblCaliber_units.setText("mm");
      s_Caliber_units = "mm";
    };
  lblCaliber_units.setText(s_Caliber_units);
}


public void handleDropListEvents(GDropList list, GEvent event)
{


}
/*
void windowDraw(GWinApplet appc, GWinData data)
{
  
  fill(0, 0, 0, 255);
  textSize(16);
  windowWeapon_settings.text("TEST", 100 , 100, 200, 50);
  
}
*/




public void load_weapon_file()
{
  String s_file_name = "weapons/" + s_selected_weapon_file;
  String[] contain = loadStrings(s_file_name);
  
  s_weapon_name = contain[0];
  s_projectile_diameter = contain[1];
  f_natural_projectile_diameter  = Float.valueOf(contain[1]).floatValue();
  if(f_natural_projectile_diameter > 20)
  {
    f_natural_projectile_diameter = 20.0;
    System.out.println("\nWARNING: Caliber value is too high, new value is set to 20 mm.");
  }
  //f_projectile_diameter = f_natural_projectile_diameter;
  txt_f_projectile_diameter = f_natural_projectile_diameter;
  
  set_units_of_caliber(f_natural_projectile_diameter);
  set_caliber_dimension();
  
  //auto reset of hit detection start 
  new_shooting_start_time = Integer.valueOf(contain[3]).intValue();
  new_shooting_start_time = new_shooting_start_time / 100;
 
  if(new_shooting_start_time < 1)
    {
      new_shooting_start_time = 1;
    };
    
  i_new_shooting_start_time_start_value = new_shooting_start_time;
  f_hit_sight_offset_X = Float.valueOf(contain[4]).floatValue() - 5000;
  f_hit_sight_offset_Y = Float.valueOf(contain[5]).floatValue() - 5000;
  
  //Try to get sound file (optional). 
  if(contain.length > 6) //on 7th line is name of sound file, first line is 1
  {
    System.out.println("Sound file: " + contain[6]);
    s_gunshot_filename = contain[6];
  }
  else //load default sound file
  {
    //s_gunshot_path = "sounds/"; can be in another directory
    System.out.println("Sound file: default_gunshot.mp3");
    s_gunshot_filename = "default_gunshot.mp3";
  }
  /*
  s_gunshot_path = "sounds/";
  System.out.println(s_gunshot_path + s_gunshot_filename);
  minim = new Minim(this);
  shot_sample = minim.loadSample(s_gunshot_path + s_gunshot_filename, 512); // filename , buffer size
  */
  println("\nWeapon file loaded");
  println(" -Weapon name: " + s_weapon_name);
  println(" -Weapon caliber: " + s_projectile_diameter + s_Caliber_units );
  println(" -New detection start time: " + (new_shooting_start_time * 100) + " milliseconds\n"  );
  

  
}

public void set_units_of_caliber(float f_caliber)
{
  if(f_caliber >= 1 ) // units of caliber
    {
     b_projectile_diameter_is_metric = true;
     s_Caliber_units = "mm";
    };
  if(f_caliber < 1 ) // units of caliber
    {
     b_projectile_diameter_is_metric = false;
     //f_projectile_diameter *= 25.4;
     s_Caliber_units = "";
    };
  if(f_caliber == 0 ) // units of caliber
    {
     b_projectile_diameter_is_metric = true;
     s_Caliber_units = "mm";
    };
}


void set_caliber_dimension()
{
  f_projectile_diameter = f_natural_projectile_diameter;
  
  if(b_projectile_diameter_is_metric != b_target_diameter_is_metric)   //target and caliber are not at same unit
  {
   if(b_projectile_diameter_is_metric == false)  //caliber is in inches
      {
       f_projectile_diameter = f_natural_projectile_diameter * 25.4;     
      }
  
   if(b_target_diameter_is_metric == false)  //target is in inches
      {
       f_projectile_diameter = f_natural_projectile_diameter / 25.4; 
      }      
  
  }
}


public void save_weapon_file()
{
  String[] s_weapon_profile = new String[6];
  //s_weapon_profile[0] = s_weapon_name;
  s_weapon_profile[0] = txtWeapon_name.getText();
  s_weapon_profile[1] = txtCaliber.getText();
  //s_weapon_profile[1] = s_projectile_diameter;
  //s_weapon_profile[1] = String.valueOf(f_projectile_diameter); //txtCaliber.getText()
  if(b_projectile_diameter_is_metric == true)
  {
     s_weapon_profile[2] = "mm"; 
  }
  if(b_projectile_diameter_is_metric == false)
  {
     s_weapon_profile[2] = "inch"; 
  }
  s_weapon_profile[3] = String.valueOf(new_shooting_start_time * 100);
  s_weapon_profile[4] = String.valueOf(f_hit_sight_offset_X + 5000);
  s_weapon_profile[5] = String.valueOf(f_hit_sight_offset_Y + 5000);
  String s_file_name = "weapons/" + s_selected_weapon_file;
  saveStrings(s_file_name, s_weapon_profile);
  System.out.println("\nWeapon profile saved into: " + s_file_name);
}
