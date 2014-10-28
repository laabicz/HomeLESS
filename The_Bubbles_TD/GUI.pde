/*
This bubble.pde is part of HomeLESS: The Bubbles TD.

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


int i_area_of_interest_background = 200;
//int i_area_of_interest_background = 255;
int i_area_of_interest_offset_X = 20;
int i_area_of_interest_offset_Y = 20;
int x_position, y_position;

//int i_area_of_interest_width = 800, i_area_of_interest_height = 600;
int i_area_of_interest_width, i_area_of_interest_height;
int i_window_resolution_X;
int i_window_resolution_Y;


void draw_stats()
{
  //SCORE label
  fill(0, 170, 30, 255);
  textSize(60);
  x_position = 10;
  y_position = i_area_of_interest_offset_Y + i_area_of_interest_height + i_area_of_interest_offset_Y +5;
  text("SCORE: ", x_position , y_position , 400, 90);
  fill(255, 0, 0, 255);
  x_position = 220;
  text(String.valueOf(i_total_score), x_position , y_position , 200.0, 90.0);
  
  //TIME label
  fill(0, 170, 30, 255);
  x_position = 360;
  text("TIME: ", x_position , y_position , 400, 90);
  fill(255, 0, 0, 255);
  x_position = 520;
  text(String.valueOf(nf(f_time_of_shooting,2,1)), x_position , y_position , 200.0, 90.0); 
}

void draw_reload_rectangle(int position_X, int position_Y, int size_X, int size_Y)
{
  b_timer = false;
  fill(255,0 , 0); //red
  fill(100); //red
  rect(position_X, position_Y, size_X, size_Y);
  fill(255);
  textSize(36);
  text("HIT HERE\nTO START! ", position_X + 55, position_Y, 240, 120);

}

