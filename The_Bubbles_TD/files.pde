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
  
  //Area of interest settings
  bubbles_ini_file_contain_parts = split(bubbles_ini_file_contain[1], "=");
  i_area_of_interest_width = Integer.valueOf(bubbles_ini_file_contain_parts[1].trim()).intValue();
  System.out.println("i_area_of_interest_width " + i_area_of_interest_width);
  
  bubbles_ini_file_contain_parts = split(bubbles_ini_file_contain[2], "=");
  i_area_of_interest_height = Integer.valueOf(bubbles_ini_file_contain_parts[1].trim()).intValue();
  System.out.println("i_area_of_interest_height " + i_area_of_interest_height);
  

  /*
  //Webcam settings:
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_webcam_line], "=");
  webcam_type = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue();
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_video_width_line], "=");
  video_width = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue();
  
  ha_ini_file_contain_parts = split(ha_ini_file_contain[i_video_height_line], "=");
  video_height = Integer.valueOf(ha_ini_file_contain_parts[1].trim()).intValue();
  */
}
