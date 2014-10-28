/*
This system.pde is part of HomeLESS: The Bubbles TD.

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



//int i_window_ressolution_X = 1000, i_window_ressolution_Y = 720;
float f_hit_position_X, f_hit_position_Y;
int i_total_score = 0;

//int i_area_of_interest_width = 800, i_area_of_interest_height = 600;



boolean b_timer = false;
int i_time_of_shooting_millis_started;
int i_time_of_shooting_millis; //millis();
float f_time_of_shooting;
int i_time_of_penalty = 0;
int i_penalty_counter = 0;
float f_time_of_shoting_maximum = 30.0;  //10- for mouse, 30 for shooting



int i_reload_rectangle_size_X = 300;
int i_reload_rectangle_size_Y = 100;
int i_reload_rectangle_position_X = i_area_of_interest_offset_X + (i_area_of_interest_width / 2) + (i_reload_rectangle_size_X / 2) - i_reload_rectangle_size_X ;
int i_reload_rectangle_position_Y = i_area_of_interest_offset_Y + (i_area_of_interest_height / 2) - (i_reload_rectangle_size_Y / 2);



void shoot_the_bubble(float X, float Y)
{
  b_timer = true;
  sound_shoot.trigger();
  check_hit_score(X, Y);
  System.out.println("X: " + X);
  System.out.println("Y: " + Y);
  System.out.println("T: " + nf(f_time_of_shooting,2,1));

  //decrease number of bullets

  i_bullets_left_counter--;

 
  //reload
  if(i_bullets_left_counter == 0)
  {
    bullet_reload();
  }
}


void check_hit_score(float hit_X, float hit_Y)
{
  f_hit_position_X = hit_X;
  f_hit_position_Y = hit_Y;
  int i_current_score = 0;
  
  for (int i =0; i < i_number_of_bubbles;i++)
  {
    if(bubble[i].hit == false)
    {
      if (dist(f_hit_position_X, f_hit_position_Y, bubble[i].f_bubble_position_X, bubble[i].f_bubble_position_Y) < i_bubble_radius_big)
      {
        bubble[i].hit=true;
        i_bubble_left--;
        i_current_score = 5;
        if (dist(f_hit_position_X, f_hit_position_Y, bubble[i].f_bubble_position_X, bubble[i].f_bubble_position_Y) < i_bubble_radius_middle)
        {
          i_current_score += 3;
          if (dist(f_hit_position_X, f_hit_position_Y, bubble[i].f_bubble_position_X, bubble[i].f_bubble_position_Y) < i_bubble_radius_center)
          {
            i_current_score += 2;
          }
        }
        i_total_score += i_current_score;
        System.out.println(bubble[i].i_bubble_id + ". bubble hit, score: " + i_current_score);
        System.out.println("Total score: " + i_total_score);
      }
    }
  }
}


void shoot_the_reset(float hit_X, float hit_Y)
{
  System.out.println("hit_X: " + hit_X);
  System.out.println("hit_Y: " + hit_Y);
  
  int i_border_X_left = i_reload_rectangle_position_X;
  int i_border_X_right = i_reload_rectangle_position_X + i_reload_rectangle_size_X;
  int i_border_Y_up = i_reload_rectangle_position_Y + i_reload_rectangle_size_Y;
  int i_border_Y_down = i_reload_rectangle_position_Y;
  boolean b_hit_in_square = false;
  
  //X border
  if((hit_X > i_border_X_left) && (hit_X < i_border_X_right))
  {
    //Y border
    if((hit_Y < i_border_Y_up) && (hit_Y > i_border_Y_down))
    {
      b_hit_in_square = true;
    }
  }
  

  
  if(b_hit_in_square)
  {
    reset();
  }
  
}


void reset()
{
  bubbles_reset();
  bullet_reload();
  i_total_score = 0;
  i_time_of_penalty = 0;
  f_time_of_shooting = 0;
  i_penalty_counter = 0;
  i_bubble_left = i_number_of_bubbles;
  b_timer = false;
}

void stop_shooting()
{
  //start with
  for (int i = 0; i < i_number_of_bubbles;i++)
  {
    bubble[i].hit = true;
    i_bubble_left = 0;
  }
}

void mousePressed()
{
  shoot_the_bubble(mouseX, mouseY);
  if(i_bubble_left == 0)
  {
    shoot_the_reset(mouseX, mouseY);
  };
}


void keyPressed()
{
  //see ASCII
  if( key == 114 )  // key == r
  {
    reset();
    //System.out.println("reset key r pressed");
  }
    
  if( key == 115)  // key == s
  {
    reset();
    stop_shooting();
    System.out.println("reset key s pressed");
  }
  
}


