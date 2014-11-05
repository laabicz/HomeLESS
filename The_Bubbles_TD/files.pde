/*
This ball.pde is part of HomeLESS: The Bubbles TD.

HomeLESS: The Bubbles TD is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or any later version.

HomeLESS: The Bubbles TD is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with HomeLESS: The Bubbles.  If not, see <http://www.gnu.org/licenses/>.
*/


//TODO load values from file bubbles.ini
void load_bubbles_ini()
{
  String[] bubbles_ini_file_contain = loadStrings("bubbles.ini");
  String[] bubbles_ini_file_contain_parts;
  
  //define lines
  //general
  int i_line_of_area_of_interest_width = 1;
  int i_line_of_area_of_interest_height = 2;
  //sound
  int i_line_of_sound_enabled = 5;
  int i_line_of_hit_example = 6;
  //shooting
  int i_line_of_bubbles_numbers = 9;
  int i_line_of_bubbles_speed_min = 10;
  int i_line_of_bubbles_speed_max = 11;
  
  //HIP
  int i_line_of_HIP_enable = 14;
  int i_line_of_source_ip_address = 15;
  int i_line_of_source_port = 16;
  
  //Area of interest settings
  bubbles_ini_file_contain_parts = split(bubbles_ini_file_contain[i_line_of_area_of_interest_width], "=");
  i_area_of_interest_width = Integer.valueOf(bubbles_ini_file_contain_parts[1].trim()).intValue();
  //System.out.println("i_area_of_interest_width " + i_area_of_interest_width);
  
  bubbles_ini_file_contain_parts = split(bubbles_ini_file_contain[i_line_of_area_of_interest_height], "=");
  i_area_of_interest_height = Integer.valueOf(bubbles_ini_file_contain_parts[1].trim()).intValue();
  //System.out.println("i_area_of_interest_height " + i_area_of_interest_height);
  
  
  bubbles_ini_file_contain_parts = split(bubbles_ini_file_contain[i_line_of_sound_enabled], "=");
  if(Integer.valueOf(bubbles_ini_file_contain_parts[1].trim()).intValue() > 0)
  {
    b_sound_enable = true;
    System.out.println("Sound enabled"); 
  }
  
  
  //bubbles
  bubbles_ini_file_contain_parts = split(bubbles_ini_file_contain[i_line_of_bubbles_numbers], "=");
  i_number_of_bubbles = Integer.valueOf(bubbles_ini_file_contain_parts[1].trim()).intValue();
  i_number_of_bullets = i_number_of_bubbles;
  
  bubbles_ini_file_contain_parts = split(bubbles_ini_file_contain[i_line_of_bubbles_speed_min], "=");
  f_bubble_velocity_min = Integer.valueOf(bubbles_ini_file_contain_parts[1].trim()).intValue();
  
  bubbles_ini_file_contain_parts = split(bubbles_ini_file_contain[i_line_of_bubbles_speed_max], "=");
  f_bubble_velocity_max = Integer.valueOf(bubbles_ini_file_contain_parts[1].trim()).intValue();
  
  
  bubbles_ini_file_contain_parts = split(bubbles_ini_file_contain[i_line_of_HIP_enable], "=");
  if(Integer.valueOf(bubbles_ini_file_contain_parts[1].trim()).intValue() > 0)
  {
    b_HIP_enable = true;//false by default
    
    bubbles_ini_file_contain_parts = split(bubbles_ini_file_contain[i_line_of_HIP_enable], "=");
    //s_Source_IP_addres = //string
    
    bubbles_ini_file_contain_parts = split(bubbles_ini_file_contain[i_line_of_source_ip_address], "=");
    s_Source_IP_addres = bubbles_ini_file_contain_parts[1].trim();

    bubbles_ini_file_contain_parts = split(bubbles_ini_file_contain[i_line_of_source_port], "=");
    i_Source_port = Integer.valueOf(bubbles_ini_file_contain_parts[1].trim()).intValue();
  }
  else
  {
   System.out.println("HIP disabled"); 
  }
  
  System.out.println("\nbubbles.ini loaded.");
  
}
