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

Ball[] myBall;

//maximum allowed balls are 20;
int i_number_of_balls = 10;
int i_ball_left = i_number_of_balls;
float i_ball_radius_big = 40;
float i_ball_radius_middle = (i_ball_radius_big * 0.7);
float i_ball_radius_center = (i_ball_radius_middle * 0.5);
float i_ball_diameter_big = 2 * i_ball_radius_big;

int i_ball_dameter;
int i_ball_dameter_small;
boolean b_all_balls_hit = false;

float f_ball_velocity_min = 1, f_ball_velocity_max = 1;  //1-4



void balls_init(int numbers)
{
  myBall = new Ball[numbers];
  
  
  for (int i =0; i < numbers;i++)
    {
      //0.1 is for get position of ball to farther from border :D
      myBall[i] = new Ball(i);
      //System.out.println("myBall[i] " + i + " has id " + myBall[i].i_ball_id);
    }
}

void balls_reset()
{
  for (int i =0; i < i_number_of_balls;i++)
  {
    myBall[i].hit = false;
    myBall[i].f_ball_position_X = random(i_area_of_interest_offset_X + i_ball_radius_big + 0.1, i_area_of_interest_width - i_ball_radius_big - 0.1);
    myBall[i].f_ball_position_Y = random(i_area_of_interest_offset_Y + i_ball_radius_big + 0.1, i_area_of_interest_height - i_ball_radius_big - 0.1);
    myBall[i].f_velocity_vector_X = random(f_ball_velocity_min, f_ball_velocity_max) * ( 1 - (int(random(0.1,1.9))*2) );
    myBall[i].f_velocity_vector_Y = random(f_ball_velocity_min, f_ball_velocity_max) * ( 1 - (int(random(0.1,1.9))*2) );
  }
};

class Ball
{
  public float f_ball_position_X, f_ball_position_Y;
  public float f_velocity_vector_X, f_velocity_vector_Y;
  public float f_time_of_hit;
  boolean b_vector_orientation_X = false; // false, negative vector -> vector < 0
  boolean b_vector_orientation_Y = false; 
  private color c1, c2, c3;
  private int i_color_big = 100, i_color_middle = 50, i_color_center = 0;
  private int i_ball_id;
  boolean hit;
  Ball[] others_balls;
  
  float position_X_min = i_area_of_interest_offset_Y + i_ball_radius_big;
  float position_X_max = i_area_of_interest_offset_Y + i_area_of_interest_width - i_ball_radius_big;
  float position_Y_min = i_area_of_interest_offset_X + i_ball_radius_big;
  float position_Y_max = i_area_of_interest_height - i_ball_radius_big;

  
  Ball(int id)
  {
    f_ball_position_X = random(position_X_min, position_X_max);
    f_ball_position_Y = random(position_Y_min, position_Y_max);

    //randomize velocity and orientation
    f_velocity_vector_X = random(f_ball_velocity_min, f_ball_velocity_max) * ( 1 - (int(random(0.1,1.9))*2) );
    f_velocity_vector_Y = random(f_ball_velocity_min, f_ball_velocity_max) * ( 1 - (int(random(0.1,1.9))*2) );

    
    //others_balls = others;
    i_ball_id = id;
    c3=#064A9B;
    c2=#2886D1;
    c1=#47C0E3;
    noStroke();
  }
  
  private void set_velocity_vector_X(float vector)
  {
    f_velocity_vector_X = vector;
    
    if(f_velocity_vector_X > 0)
    {
      b_vector_orientation_X = true;
    }
    else
    {
      b_vector_orientation_X = false;
    }
  }
  
  private void set_velocity_vector_Y(float vector)
  {
    f_velocity_vector_Y = vector;
    
    if(f_velocity_vector_Y < 0)
    {
      b_vector_orientation_Y = true;
    }
    else
    {
      b_vector_orientation_Y = false;
    }
  }
  
    
  void collision_check()
  {
    //(i_ball_id + 1) - ball cannot be checked with itself
    for (int i = i_ball_id + 1; i < i_number_of_balls; i++)
    {
      float f_delta_X = (f_ball_position_X - myBall[i].f_ball_position_X);
      float f_delta_Y = (f_ball_position_Y - myBall[i].f_ball_position_Y);
     
      float f_distance = sqrt((f_delta_X * f_delta_X) + (f_delta_Y * f_delta_Y));
      
      float f_velocity_temp_X = 0;
      float f_velocity_temp_Y = 0;
        
      float f_minimal_distance = i_ball_diameter_big;
      if((f_distance < f_minimal_distance) && !myBall[i].hit && !hit)
      {  

        float f_distance_vector_angle = (atan2(f_delta_Y, f_delta_X));

        f_ball_position_X = myBall[i].f_ball_position_X + (cos(f_distance_vector_angle) * f_minimal_distance * 1.0); // X
        f_ball_position_Y = myBall[i].f_ball_position_Y + (sin(f_distance_vector_angle) * f_minimal_distance * 1.0); // Y
               
        f_velocity_temp_X = f_velocity_vector_X;
        f_velocity_temp_Y = f_velocity_vector_Y;
        
        set_velocity_vector_X(myBall[i].f_velocity_vector_X);
        set_velocity_vector_Y(myBall[i].f_velocity_vector_Y);
        myBall[i].set_velocity_vector_X(f_velocity_temp_X);
        myBall[i].set_velocity_vector_Y(f_velocity_temp_Y);
        
        //ruzny smer, tak je prohodit
        if(b_vector_orientation_X == myBall[i].b_vector_orientation_X)
        {
          if(f_velocity_vector_X > myBall[i].f_velocity_vector_X)
          {
            f_velocity_vector_X *= -1;
          }
          else
          {
            myBall[i].f_velocity_vector_X *= -1;
          }
        }
        
        if(b_vector_orientation_Y == myBall[i].b_vector_orientation_Y)
        {
          if(f_velocity_vector_Y > myBall[i].f_velocity_vector_Y)
          {
            f_velocity_vector_Y *= -1;
          }
          else
          {
            myBall[i].f_velocity_vector_Y *= -1;
          }
        }
        
      }//end of distance and hit ball condition
      
      
    }
  }
  
  
  void move()
  {
    f_ball_position_X += f_velocity_vector_X;
    f_ball_position_Y += f_velocity_vector_Y;
    
    //X axis
    //left border
    if(f_ball_position_X < i_ball_radius_big + i_area_of_interest_offset_X)
    {
      f_velocity_vector_X *= -1;
      f_ball_position_X = i_ball_radius_big + i_area_of_interest_offset_X;
    }
    
    //right border
    if(f_ball_position_X > (i_area_of_interest_width + i_area_of_interest_offset_X - i_ball_radius_big))
    {
      f_velocity_vector_X *= -1;
      f_ball_position_X = i_area_of_interest_width + i_area_of_interest_offset_X - i_ball_radius_big;
    }


    //Y axis
    //left border
    if(f_ball_position_Y < i_ball_radius_big + i_area_of_interest_offset_Y)
    {
      f_velocity_vector_Y *= -1;
      f_ball_position_Y = i_ball_radius_big + i_area_of_interest_offset_Y;
    }
    
    //right border
    if(f_ball_position_Y > (i_area_of_interest_height + i_area_of_interest_offset_Y - i_ball_radius_big))
    {
      f_velocity_vector_Y *= -1;
      f_ball_position_Y = i_area_of_interest_height + i_area_of_interest_offset_Y - i_ball_radius_big;
    }

  }

  void display()
  {
    if(!hit)
    {

      //big
      fill(0);
      ellipse(f_ball_position_X, f_ball_position_Y, i_ball_diameter_big, i_ball_diameter_big);
      
      //middle
      fill(255);
      ellipse(f_ball_position_X, f_ball_position_Y, i_ball_radius_middle * 2, i_ball_radius_middle * 2);
      
      //center
      fill(0);
      ellipse(f_ball_position_X, f_ball_position_Y, i_ball_radius_center * 2, i_ball_radius_center * 2);
    }
    /*
    else
    {
      fill(#FF2929, 110);
      ellipse(f_ball_position_X, f_ball_position_Y, i_ball_diameter_big, i_ball_diameter_big);
      fill(#FF2929, 100);
      ellipse(f_ball_position_X, f_ball_position_Y, i_ball_radius_middle * 2, i_ball_radius_middle * 2);
      fill(#FF2929, 120);
      ellipse(f_ball_position_X, f_ball_position_Y, i_ball_radius_center * 2, i_ball_radius_center * 2);
    }
    */
  }
}

