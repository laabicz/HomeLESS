/*
This bullet.pde is part of HomeLESS: The Bubbles TD.

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

Bullet[] myBullet;
int i_number_of_bullets = 10, i_bullets_left_counter;;

void bullet_init(int numbers)
{
  myBullet = new Bullet[numbers];
  for (int i = 0; i < numbers; i++)
  {
    myBullet[i] = new Bullet(i_area_of_interest_offset_X + 10 + (i * 15), i_area_of_interest_height);
  }
  i_bullets_left_counter = numbers;
}

void bullet_reload()
{
    //millis();
    //sound_reload.trigger();
    i_bullets_left_counter =  i_number_of_bullets;
    //i_time_of_penalty++;
    i_time_of_penalty += 2;
    i_penalty_counter++;
    System.out.println("Penalty for reload, +2 second.");
}

class Bullet
{
  int position_X, position_Y;

  Bullet(int X, int Y)
  {
    position_X = X;
    position_Y = Y;
  }

  void display()
  {
    fill(0);
    rect(position_X, position_Y, 5, 15);
  }
}
