/*
This win_target_config.pde is part of HomeLESS Hit Analyzer.

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


GWindow windowTarget_settings;

GTextField txtSimulated_Distance, txtReal_Distance;
GDropList dropList_target_selection;
GCheckbox cbxMetric_units;
GImageButton btnMinus, btnPlus, btnTarget_sync, btnSave_target;
GLabel lblCorrection, lblSelect_target;
GLabel lblSimulated_distance, lblReal_distance, lblSimulated_Distance_units, lblReal_Distance_units, lblUseMetricSystem;
public String s_Select_target_label, s_Correction_label, s_meters, s_yards, s_distance_units,  s_Use_metric_system; // "yd"


public void createwindowWeapon_target_settings()
{ 
  
  windowTarget_settings = new GWindow(this, "HA - Target settings", 400, 200, 330, 210, false, JAVA2D);
  //windowTarget_settings = new GWindow(this, "HA - Target settings", 400, 200, 330, 210, false, P2D);
  PApplet win_target = windowTarget_settings.papplet;
  windowTarget_settings.setActionOnClose(GWindow.CLOSE_WINDOW);
  windowTarget_settings.addDrawHandler(this, "windowTarget_settings_draw");
  

  //g4p_controls.GTextAlign.setText(String, );
  //GAlign.LEFT;
 
  //target selection dropdown list
  x_position = 20;
  y_position = 10;
  
  //lbl lblSelect_target;
  lblSelect_target = new GLabel(win_target, x_position, y_position, 180, 20);
  lblSelect_target.setText(s_Select_target_label + s_colon_with_space);
  lblSelect_target.setOpaque(false);
  lblSelect_target.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);

  y_position += 20;
  dropList_target_selection = new GDropList(win_target, x_position, y_position, 150, 80, 5);
  dropList_target_selection.setItems(loadStrings("targets/list_of_targets"), i_selected_target_number);
  dropList_target_selection.addEventHandler(this, "dropList_target_selection"); 
 
  
  //ghost callibration target corrections
  x_position = 230;
  y_position = 40;
  
  lblCorrection = new GLabel(win_target, x_position - 30, y_position - 30, 180, 20);
  lblCorrection.setText(s_Correction_label + s_colon_with_space);
  lblCorrection.setOpaque(false);
  lblCorrection.setTextAlign(GAlign.LEFT, GAlign.MIDDLE);
  
  
  y_position += 20;
  //off over click
  images = new String[] { "graphics/arrow_up_1.png", "graphics/arrow_up_2.png", "graphics/arrow_up_3.png" };
  btnCorrection_up = new GImageButton(win_target, x_position, y_position - 30, images);
  btnCorrection_up.tag = "Correction_up";
 
  images = new String[]{ "graphics/arrow_left_1.png", "graphics/arrow_left_2.png", "graphics/arrow_left_3.png" };
  btnCorrection_left = new GImageButton(win_target, x_position -30, y_position, images);
  btnCorrection_left.tag = "Correction_left";
  
  images = new String[]{ "graphics/arrow_down_1.png", "graphics/arrow_down_2.png", "graphics/arrow_down_3.png" };
  btnCorrection_down = new GImageButton(win_target, x_position, y_position, images);
  btnCorrection_down.tag = "Correction_down";
  
  images = new String[]{ "graphics/arrow_right_1.png", "graphics/arrow_right_2.png", "graphics/arrow_right_3.png" };
  btnCorrection_right = new GImageButton(win_target, x_position + 30, y_position, images);
  btnCorrection_right.tag = "Correction_right";
  
  images = new String[]{ "graphics/minus_1.png", "graphics/minus_2.png", "graphics/minus_3.png" };
  btnMinus = new GImageButton(win_target, x_position - 30 , y_position - 30, images);
  btnMinus.tag = "Correction_minus";
  
  images = new String[]{ "graphics/plus_1.png", "graphics/plus_2.png", "graphics/plus_3.png" };
  btnPlus = new GImageButton(win_target, x_position + 30 , y_position - 30, images );
  btnPlus.tag = "Correction_plus";
  
  images = new String[]{ "graphics/scale_reset_1.png", "graphics/scale_reset_2.png", "graphics/scale_reset_3.png" };
  btnScale_reset = new GImageButton(win_target, x_position + 60 , y_position - 30, images);
  btnScale_reset.tag = "Reset_scale";
  
  images = new String[]{ "graphics/correction_reset_1.png", "graphics/correction_reset_2.png", "graphics/correction_reset_3.png" };
  btnCorrection_reset = new GImageButton(win_target, x_position + 60 , y_position, images);
  btnCorrection_reset.tag = "Correction_reset";
  

  
  
  // distances settings
  x_position = 20;
  y_position = 110;
  lblSimulated_distance = new GLabel(win_target, x_position, y_position, 140, 20);
  lblSimulated_distance.setText(s_Simulated_distance);
  lblSimulated_distance.setTextAlign(GAlign.LEFT, GAlign.MIDDLE );
  lblSimulated_distance.setOpaque(false);
  txtSimulated_Distance = new GTextField(win_target, x_position + 150, y_position, 60, 18);
  txtSimulated_Distance.setText(String.valueOf(f_simulated_distance));
  txtSimulated_Distance.addEventHandler(this, "handle_txtSimulated_distance");
  lblSimulated_Distance_units = new GLabel(win_target, x_position +215, y_position, 50, 18);
  lblSimulated_Distance_units.setText(s_distance_units);  //redefine this to variable
  lblSimulated_Distance_units.setTextAlign(GAlign.LEFT, GAlign.MIDDLE );
  
  y_position += 25;
  lblReal_distance = new GLabel(win_target, x_position, y_position, 140, 20);
  lblReal_distance.setText(s_Real_distance);
  lblReal_distance.setTextAlign(GAlign.LEFT, GAlign.MIDDLE );
  lblReal_distance.setOpaque(false);
  txtReal_Distance = new GTextField(win_target, x_position + 150, y_position, 60, 18);
  txtReal_Distance.setText(String.valueOf(f_real_distance));
  txtReal_Distance.addEventHandler(this, "handle_txtReal_distance");
  lblReal_Distance_units = new GLabel(win_target, x_position +215, y_position, 50, 18);
  lblReal_Distance_units.setText(s_distance_units);
  lblReal_Distance_units.setTextAlign(GAlign.LEFT, GAlign.MIDDLE );
  
  y_position += 25;
  lblUseMetricSystem = new GLabel(win_target, x_position, y_position, 150, 18);
  lblUseMetricSystem.setText(s_Use_metric_system + s_colon_with_space);
  lblUseMetricSystem.setTextAlign(GAlign.LEFT, GAlign.MIDDLE );
  x_position += 145;
  cbxMetric_units = new GCheckbox(win_target, x_position , y_position, 22, 18, " ");
  cbxMetric_units.setSelected(b_distance_units_are_metric);
  cbxMetric_units.addEventHandler(this, "cbxMetric_units_clicked");
  
  x_position = 240;
  y_position = 170;
  images = new String[]{ "graphics/save_1.png", "graphics/save_2.png", "graphics/save_3.png" };
  btnSave_target = new GImageButton(win_target, x_position, y_position, images);
  btnSave_target.tag = "Save_target";  
  /*
  //target synchronization via HIP
  x_position = 20;
  y_position = 200;
  images = new String[]{ "graphics/target_sync_1.png", "graphics/target_sync_1.png", "graphics/target_sync_1.png" };
  btnTarget_sync = new GImageButton(win_target, x_position + 60 , y_position, images);
  btnTarget_sync.tag = "Target_sync";
  */
}

synchronized public void windowTarget_settings_draw(GWinApplet appc, GWinData data)
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



public void dropList_target_selection(GDropList source, GEvent event)
{ 

  
  s_selected_target_name = dropList_target_selection.getSelectedText();
  load_target_file();
  set_caliber_dimension();  //because of unit of caliber and target
  //println("\nSelected target: " + dropList_target_selection.getSelectedText());
  //println("diameters_center_X: " + target_diameters_center_X);
  //println("diameters_center_Y: " + target_diameters_center_Y );
}

public void send_target_data()
{
  if(b_hip_enable)
   {
      String message;    // the message to send
     
      // formats the message for Pd
      message ="";
      // send the message
      udp.send( message, s_Destination_IP_address, i_Destination_port );
   } 
}



void handle_txtSimulated_distance(GTextField textfield, GEvent event)
{
    switch(event)
    {
    case CHANGED: 
      b_shortcuts = false;
      break;
    case ENTERED:
      f_simulated_distance = Float.parseFloat(txtSimulated_Distance.getText());
      f_real_distance = Float.parseFloat(txtReal_Distance.getText());
      System.out.println("\nInserted simulated shooting distance: " + f_simulated_distance);
      System.out.println("\nInserted real shooting distance: " + f_real_distance);
      break;
    }
};


void handle_txtReal_distance(GTextField textfield, GEvent event)
{
    switch(event)
    {
    case CHANGED: 
      b_shortcuts = false;
      break;
    case ENTERED:
      f_simulated_distance = Float.parseFloat(txtSimulated_Distance.getText());
      f_real_distance = Float.parseFloat(txtReal_Distance.getText());
      System.out.println("\nInserted simulated shooting distance: " + f_simulated_distance);
      System.out.println("\nInserted real shooting distance: " + f_real_distance);
      break;
    }
};

public void cbxMetric_units_clicked(GCheckbox checkbox, GEvent event)
{
  if(b_distance_units_are_metric == false)
    {
      b_distance_units_are_metric = true;
      s_distance_units = s_meters;
      System.out.println("\nDistance units are meters.");
    }
  else  //if(b_invert_hit_X == false)
    {
      b_distance_units_are_metric = false;
      s_distance_units = s_yards;
      System.out.println("\nDistance units are yards.");
    };
    
    lblSimulated_Distance_units.setText(s_distance_units);
    lblReal_Distance_units.setText(s_distance_units);
};


