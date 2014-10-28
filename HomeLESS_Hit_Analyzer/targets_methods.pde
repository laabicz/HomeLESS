/*
This targets_method.pde is part of HomeLESS Hit Analyzer.

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

public boolean b_target_diameter_is_metric = true;
public int  number_of_black_diameter, number_of_biggest_diameter, t_black_center_image_size, t_white_border_image_size;
public int t_black_center_image_size_autoscaled, t_white_border_image_size_autoscaled;
public float f_targets_diameters[];
public float f_hit_X = -5000, f_hit_Y = -5000,last_f_hit_Y = -5000, last_f_hit_X = -5000, f_delta_X, f_delta_Y;
public int brightestX_high, brightestX_low, brightestY_high, brightestY_low, brightestValue, i_detection_level = 254;
public int hit_points_actual =0, hit_points_last = 0, hit_points_sum = 0, hit_counter = 0, hit_areas_ok = 0;
public float f_projectile_diameter, txt_f_projectile_diameter;
public float f_current_radius, f_maximum_radius, f_diameter_scale, f_diameter_scale_autoscaled, f_radius_scale, target_scale, f_center_range = 0, square_max_lenght, f_square_scale, last_target_scale = 0;
public float A1X_autoscaled = 0, A1Y_autoscaled = 0, A2X_autoscaled = 0, A2Y_autoscaled = 0, B1X_autoscaled = 0, B1Y_autoscaled = 0, B2X_autoscaled = 0, B2Y_autoscaled = 0, CX_autoscaled = 0, CY_autoscaled = 0;
public float A1X = 0, A1Y = 0, A2X = 0, A2Y = 0, B1X = 0, B1Y = 0, B2X = 0, B2Y = 0, CX = 0, CY = 0, areas_width, areas_height, areas_side_ratio;
public float side_A1X, side_A1Y, side_A2X, side_A2Y, side_B1X, side_B1Y, side_B2X, side_B2Y;
public float f_hit_remap_range_min_X = 0, f_hit_remap_range_min_Y = 0, f_hit_remap_range_max_X = 0, f_hit_remap_range_max_Y = 0;
//public String[] s_default_air_rifle_cz_tgt = {"Air Rifle CZ", "0", "120", "108", "96", "84", "72", "60", "48", "36", "24", "12", "7"};


public void analyze_the_target()
{
  //Recognize target
  //circle target, metric units
  System.out.println("\nTarget file loaded.");
  /*
  if(f_targets_diameters[0] == 0)
    { 
     System.out.println("- Target type: Cirlce target. \n- Units: Milimeters.\n");
     b_target_diameter_is_metric = true;
     circle_target_analyze();
    };
  
  //square circle target, metric units
  if(f_targets_diameters[0] == 1)
    { 
     System.out.println(" - Target type: Square target. \n- Units: Milimeters.\n");
     b_target_diameter_is_metric = true;
     square_circle_target_analyze();
    };

  //circle target, inches units
  if(f_targets_diameters[0] == 2)
    {
     System.out.println(" - Target type: Circle target. \n- Units: Inches.\n");
     b_target_diameter_is_metric = false;
     circle_target_analyze();
    };

  //square circle target, inches units
  if(f_targets_diameters[0] == 3)
    { 
     System.out.println("- Target type: Square target. \n- Units: Inches.\n");
     b_target_diameter_is_metric = false;
     square_circle_target_analyze();
    };
  
  //monoscope target
  if(f_targets_diameters[0] == 4)
    { 
     System.out.println("- Target type: Monoscope.");
     b_target_diameter_is_metric = true;
     square_circle_target_analyze();
    };
  */
    if(i_target_type == 0)
    { 
     System.out.println(" -Target type: Cirlce target.\n -Target's units: Milimeters.\n");
     b_target_diameter_is_metric = true;
     circle_target_analyze();
    };
    if(i_target_type == 1)
    { 
     System.out.println(" -Target type: Square target.\n -Target's units: Milimeters.\n");
     b_target_diameter_is_metric = true;
     square_circle_target_analyze();
    };

  //circle target, inches units
  if(i_target_type == 2)
    {
     System.out.println(" -Target type: Circle target.\n -Target's units: Inches.\n");
     b_target_diameter_is_metric = false;
     circle_target_analyze();
    };

  //square circle target, inches units
  if(i_target_type == 3)
    { 
     System.out.println(" -Target type: Square target.\n -Target's units: Inches.\n");
     b_target_diameter_is_metric = false;
     square_circle_target_analyze();
    };
  
  //monoscope target
  if(i_target_type == 4)
    { 
     System.out.println(" -Target type: Monoscope.");
     b_target_diameter_is_metric = true;
     square_circle_target_analyze();

    };
  
  t_black_center_image_size_autoscaled = round(f_targets_diameters[number_of_black_diameter] * f_diameter_scale);
  t_white_border_image_size_autoscaled = round(f_targets_diameters[number_of_biggest_diameter] * f_diameter_scale);

};

public void scale_the_target()
{
  if((i_target_type == 0) || (i_target_type == 2))
    { 
    circle_target_scaling();
    };
  if((i_target_type == 1) || (i_target_type == 3) || (i_target_type == 4))
    { 
    square_circle_target_scaling();
    };  
  
}




void find_position_of_hit()
{
   video.loadPixels();
   // reset position of the brightest pixel
   brightestX_high = 0; 
   brightestY_high = 0;
   brightestX_low = 0;
   brightestY_low = 0;
   brightestValue = 0; // Brightness of the brightest video pixel
  //for best result must be picture monochromatic
  //scanning the picture from top left to botom right
  int index = 0;
  i_detection_level = 255 - i_sensitivity;
  //System.out.println("\n  Detection start: " + millis());
  for (int y = 0; y < video_height; y++)
    {
      for (int x = 0; x < video_width; x++)
      {
        // Get the color stored in the pixel
        int pixelValue = video.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);//8-bit only :(
        // filttering the brightest pixel
        if (pixelBrightness > i_detection_level) //sensitive
        {
          // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        // This select the first brightest pixel
          if (pixelBrightness > brightestValue)
          {
            brightestValue = int(pixelBrightness);
            brightestY_high = y;
            brightestX_high = x;
          }
          //This select the last brightest pixel
          brightestY_low = y;
          brightestX_low = x;
        }
        index++;
      }
    }
    
  //System.out.println("  Detection finished: " + millis());
  f_hit_Y = (brightestY_high + brightestY_low) / 2.0; // X-coordinate of the brightest video pixel
  f_hit_X = (brightestX_high + brightestX_low) / 2.0; // Y-coordinate of the brightest video pixel
  
  //inverting X-axis of hit, with rear camera
  if(b_invert_hit_X == true)
    {
    f_hit_X = map(f_hit_X, 0, video_width, video_width, 0);
    };
    
    
  if(f_hit_X <= 0)
    {
    f_hit_X = - 5000;  
    };
    
  if(f_hit_Y <= 0)
    {
    f_hit_Y = - 5000;  
    };

  if(hit_is_in_screen())
    {
      f_hit_X +=  f_hit_sight_offset_X;
      f_hit_Y +=  f_hit_sight_offset_Y;
    }

};


public void calculate_hit_range()
{
  // This calculate the center betwen first and last brightest pixel
  //f_hit_Y = (brightestY_high + brightestY_low) / 2.0; // X-coordinate of the brightest video pixel
  //f_hit_X = (brightestX_high + brightestX_low) / 2.0; // Y-coordinate of the brightest video pixel
    // This calculate the center betwen first and last brightest pixel
  //System.out.println("f_hit_X :" + f_hit_X);
  //System.out.println("f_hit_Y :" + f_hit_Y);

  f_delta_X = target_diameters_center_X + correction_X - f_hit_X; // plus offset
  f_delta_Y = target_diameters_center_Y + correction_Y - f_hit_Y; // plus offset
  //System.out.println("f_delta_X: " + f_delta_X);
  //System.out.println("f_delta_Y: " + f_delta_Y);
  // Calculate distance from center
  f_center_range = sqrt((f_delta_X * f_delta_X)+ (f_delta_Y * f_delta_Y));
  //f_center_range = round(f_center_range);
  
  //DEBUG accuracy
  /*
  System.out.println("f_center_range: " + f_center_range);
  System.out.println("f_hit_X: " + f_hit_X);
  System.out.println("f_hit_X: " + f_hit_X);
  */
  
  
  
}

public void hit_area_test()
{
  hit_areas_ok =0; // init
  // make border depended on projectile diameter
  //test area A
  //left up corner of area A
  side_A1X = A1X + correction_X;
  side_A1X -= (f_projectile_diameter * f_radius_scale);
  side_A1Y = A1Y + correction_Y;
  side_A1Y -= (f_projectile_diameter * f_radius_scale);
  //right down corner of area A
  side_A2X = side_A1X + A2X;
  side_A2X += (f_projectile_diameter * f_diameter_scale);// side_A1X is shiftet by radius, so its necesary to shift side_A2X with twice radius (diameter)
  side_A2Y = side_A1Y + A2Y;
  side_A2Y += (f_projectile_diameter * f_diameter_scale);
  
  if((f_hit_X > side_A1X) && (f_hit_Y > side_A1Y))
  {
    if((f_hit_X < side_A2X) && (f_hit_Y < side_A2Y))
    {
     hit_areas_ok = 1;
    }
  };
  
  //test area B
  //left up corner of area B
  side_B1X = B1X + correction_X;
  side_B1X -= (f_projectile_diameter * f_radius_scale);
  side_B1Y = B1Y + correction_Y;
  side_B1Y -= (f_projectile_diameter * f_radius_scale);
  //right down corner of area B
  side_B2X = side_B1X + B2X;
  side_B2X += (f_projectile_diameter * f_diameter_scale);
  side_B2Y = side_B1Y + B2Y;
  side_B2Y += (f_projectile_diameter * f_diameter_scale);
  
  if((f_hit_X > side_B1X) && (f_hit_Y > side_B1Y))
  {
    if((f_hit_X < side_B2X) && (f_hit_Y < side_B2Y))
    {
     hit_areas_ok = 1;
    }
  };
  
  
  
  
}



public void hit_points_calculation()
{
  
  //f_targets_diameters = at_airgun_cz_diameters;  // this will be in combobox targets handeler
  // radius scale make diameters to radius
  f_maximum_radius = int((f_targets_diameters[number_of_biggest_diameter] + f_projectile_diameter) * f_radius_scale);
  //hit_area_test();
  
  if((i_target_type == 0) || (i_target_type == 2))// cirlce target
  {
    for(int i = 1; i < 11 ;i++ ) 
    {
      f_current_radius = (f_targets_diameters[i] + f_projectile_diameter) * f_radius_scale;
       if(f_center_range <= f_current_radius)
         {
         hit_points_actual = i;
         }
       if(f_center_range > f_maximum_radius)
       hit_points_actual = 0;
    }
  };
  
  
  
  if((i_target_type == 1) || (i_target_type == 3) || (i_target_type == 4)) //circle square target
  {
    hit_area_test();
    if(hit_areas_ok == 1)
    {
      for(int i = 1; i < 11 ;i++ )
      {
         f_current_radius = (f_targets_diameters[i] + f_projectile_diameter) * f_radius_scale;
         if(f_center_range <= f_current_radius)
           {
           hit_points_actual = i;
           }
        if(f_center_range > f_maximum_radius)
        hit_points_actual = 0;
      }
    }
    
    if(hit_areas_ok ==0)
    {
      hit_points_actual = 0;
    }
    //hit_areas_ok =0;
  };
  
  
  if(b_Shooting)
    {
      hit_points_sum += hit_points_actual;
    }
  if(b_hit_limit == false)
    {
      hit_points_sum = 0;
    }
  /*
  if(b_freerun_style)
     {
      hit_points_sum = 0;
     }
  */
};



//target analyze

public void set_number_of_biggest_diameter()
{
   if(f_targets_diameters[1] != 0)
       {
         number_of_biggest_diameter = 1;
       }
   else for(int i = 1; i <= 9; i++) 
         { 
           //System.out.println("i: " + i);  // numbers of circles
           if(f_targets_diameters[i] == 0)
           {
             number_of_biggest_diameter = (i + 1);
           }
           else break;
         };
 //System.out.println("Number_of_biggest_diameter: " + number_of_biggest_diameter); 
}


public void circle_target_analyze()
{
  number_of_black_diameter = int(f_targets_diameters[11]);
  f_diameter_scale_autoscaled = (video_height - 24) / f_targets_diameters[number_of_biggest_diameter];  //automatic scaling for maximum diameter
  f_diameter_scale = f_diameter_scale_autoscaled; //first init f_diameter_scale
  f_radius_scale = f_diameter_scale / 2; //first init radius scale
  //i_target_type = 0;
};


public void square_circle_target_analyze()
{
    float shift_X, shift_Y;
    number_of_black_diameter = int(f_targets_diameters[11]);

    areas_height = A2Y + B2Y;
    //areas width
    if((A1X + A2X) <= B2X)
    {
      areas_width = B2X;
    }
    else
    {
      areas_width =  A1X + A2X;
    };
    
    
    
    //System.out.println("f_resolution_ratio: " + f_resolution_ratio); 
    //System.out.println("areas_width: " + areas_width); 
    //System.out.println("areas_height: " + areas_height); 
    
    //areas side ratio
    areas_side_ratio = areas_width / (areas_height * f_resolution_ratio);
    //System.out.println("areas_side_ratio: " + areas_side_ratio); 
    
    if (areas_side_ratio <= 1)
    {
      f_square_scale = (video_height - 50) / areas_height;
      //System.out.println("f_square_scale: " + f_square_scale); 

    }
    else
    {
      f_square_scale = (video_width - 50) / areas_width;
      //System.out.println("f_square_scale: " + f_square_scale); 
    };
    
    A1X_autoscaled = A1X * f_square_scale;
    A1Y_autoscaled = A1Y * f_square_scale;
    A2X_autoscaled = A2X * f_square_scale;
    A2Y_autoscaled = A2Y * f_square_scale;
    B1X_autoscaled = B1X * f_square_scale; 
    B1Y_autoscaled = B1Y * f_square_scale;
    B2X_autoscaled = B2X * f_square_scale;
    B2Y_autoscaled = B2Y * f_square_scale;
    CX_autoscaled = CX * f_square_scale;
    CY_autoscaled = CY * f_square_scale;
    
    // first init
    A1X = A1X_autoscaled;
    A1Y = A1Y_autoscaled;
    A2X = A2X_autoscaled;
    A2Y = A2Y_autoscaled;
    B1X = B1X_autoscaled; 
    B1Y = B1Y_autoscaled;
    B2X = B2X_autoscaled;
    B2Y = B2Y_autoscaled;
    CX = CX_autoscaled;
    CY = CY_autoscaled;
    

    shift_X = (video_width - (areas_width * f_square_scale)) / 2;
    shift_Y = (video_height - (areas_height * f_square_scale)) / 2;
    //shift_Y_init = shift_Y;
    A1X += shift_X;
    A1Y += shift_Y;
    B1X += shift_X;
    B1Y += shift_Y;
    
    //DEBUG accuracy
    /*
    System.out.println("A1X: " + A1X); 
    System.out.println("A1Y: " + A1Y); 
    System.out.println("A2X: " + A2X); 
    System.out.println("A2Y: " + A2Y); 
    System.out.println("B1Y: " + B1Y); 
    */
    
    
    target_diameters_center_X = (int)(CX + shift_X);
    target_diameters_center_Y = (int)(CY + shift_Y);  
    
    //prepare for method target_scale
    A1X_autoscaled = A1X;
    A1Y_autoscaled = A1Y;
    B1X_autoscaled = B1X;
    B1Y_autoscaled = B1Y;



    f_diameter_scale = f_square_scale;//first init f_diameter_scale 
    f_diameter_scale_autoscaled = f_diameter_scale;
    


    f_radius_scale = f_diameter_scale / 2.0; //first init radius scale
    //i_target_type = 1; 
 
}

public void circle_target_scaling()
{
  if(last_target_scale != target_scale)
  {
    f_diameter_scale = f_diameter_scale_autoscaled * target_scale;
    f_radius_scale = f_diameter_scale / 2.0;
    last_target_scale = target_scale;
    t_black_center_image_size = round(t_black_center_image_size_autoscaled * target_scale);
    t_white_border_image_size = round(t_white_border_image_size_autoscaled * target_scale);
  }
}

public void square_circle_target_scaling()
{
  //this damm method I did for 5 hours...
  if(last_target_scale != target_scale)
  {
    f_diameter_scale = f_diameter_scale_autoscaled * target_scale;
    f_radius_scale = f_diameter_scale / 2.0;
    last_target_scale = target_scale;
    t_black_center_image_size = round(t_black_center_image_size_autoscaled * target_scale);
    t_white_border_image_size = round(t_white_border_image_size_autoscaled * target_scale);
    
    A2X = A2X_autoscaled * target_scale;
    A2Y = A2Y_autoscaled * target_scale;
    A1X = A1X_autoscaled - (((A2X_autoscaled * target_scale) - A2X_autoscaled ) / 2);
    A1Y = A1Y_autoscaled + (CY_autoscaled - (CY_autoscaled * target_scale));


    B2X = B2X_autoscaled * target_scale;
    B2Y = B2Y_autoscaled * target_scale;
    B1X = B1X_autoscaled - (((B2X_autoscaled * target_scale) - B2X_autoscaled ) / 2);
    B1Y = A2Y + A1Y;
    
    
  }
};

boolean hit_is_in_screen()
{
  if(((f_hit_X)> 15) && ((f_hit_X) < video_width -15))
     {
        if(((f_hit_Y) > 15) && ((f_hit_Y) < video_height -15))
        { 
          return true;
        };  
     }
  //else 
    return false;
};

boolean hit_without_sight_offset_is_in_screen()
{
  if(((f_hit_X - f_hit_sight_offset_X)> 15) && ((f_hit_X - f_hit_sight_offset_X) < video_width -15))
     {
        if(((f_hit_Y - f_hit_sight_offset_Y) > 15) && ((f_hit_Y - f_hit_sight_offset_Y) < video_height -15))
        {
          //System.out.println("--true");          
          return true;
        }   
     }
  //else 
  //System.out.println("--false");    
  return false;
};

boolean last_hit_is_in_screen()
{
  if(((last_f_hit_X)> 15) && ((last_f_hit_X) < video_width -15))
     {
        if(((last_f_hit_Y) > 15) && ((last_f_hit_Y) < video_height -15))
        { 
          //System.out.println("last_hit_is_in_screen: true");
          return true;
        }   
     }
  //else 
  //System.out.println("last_hit_is_in_screen: false");
  return false;
};

boolean last_hit_without_sight_offset_is_in_screen()
{
  if(((last_f_hit_X - f_hit_sight_offset_X)> 15) && ((last_f_hit_X - f_hit_sight_offset_X) < video_width -15))
     {
      if(((last_f_hit_Y - f_hit_sight_offset_Y) > 15) && ((last_f_hit_Y - f_hit_sight_offset_Y) < video_height -15))
        {
          //System.out.println("last_hit_without_sight_offset_is_in_screen: true");
          return true;
        }   
     }
  //else 
  //System.out.println("last_hit_without_sight_offset_is_in_screen: false");
  return false;

};


