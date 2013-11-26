/*
This ballistic_method.pde is part of HomeLESS Hit Analyzer.

HomeLESS Hit Analyzer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or any later version.

HomeLESS: Hit Analyzer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with <insert software name>.  If not, see <http://www.gnu.org/licenses/>.
*/

public int y_projectile_shift; //for basic ballistics
public int real_distance, shooting_distance;
public float real_size, shooting_size;


public void load_ballistics_data()
{
  System.out.println("Ballistic data file loaded \n");
  y_projectile_shift = 0;
};


