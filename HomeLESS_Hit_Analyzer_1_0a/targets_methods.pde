
public int  number_of_black_diameter, number_of_biggest_diameter, t_black_center_image_size, t_white_border_image_size;
public int t_black_center_image_size_autoscaled, t_white_border_image_size_autoscaled;
public float targets_diameters[];
public int brightestX_high, brightestX_low, brightestY_high, brightestY_low, brightestValue;
public int hit_points_actual =0, hit_points_last = 0, hit_points_sum = 0, hit_counter = 0, delta_X, delta_Y, hit_X, hit_Y, last_hit_Y, last_hit_X, hit_areas_ok = 0;
public float projectile_diameter, txt_projectile_diameter;
public float current_radius, maximum_radius, diameter_scale, diameter_scale_autoscaled, radius_scale, target_scale, center_range = 0, square_max_lenght, square_scale, last_target_scale = 0;
public float A1X_autoscaled = 0, A1Y_autoscaled = 0, A2X_autoscaled = 0, A2Y_autoscaled = 0, B1X_autoscaled = 0, B1Y_autoscaled = 0, B2X_autoscaled = 0, B2Y_autoscaled = 0, CX_autoscaled = 0, CY_autoscaled = 0;
public float A1X = 0, A1Y = 0, A2X = 0, A2Y = 0, B1X = 0, B1Y = 0, B2X = 0, B2Y = 0, CX = 0, CY = 0, areas_width, areas_height, areas_side_ratio;
public float side_A1X, side_A1Y, side_A2X, side_A2Y, side_B1X, side_B1Y, side_B2X, side_B2Y;
public float shift_Y_init;
public void analyze_the_target()
{
  //Recognize target
  //circle target, square circle target
  if(targets_diameters[0] == 0)
    { 
    circle_target_analyze();
    };
  
  //square circle target
  if(targets_diameters[0] == 1)
    { 
    square_circle_target_analyze();
    };
  //for circle target and square circle target
  //radius_scale = diameter_scale / 2;
  t_black_center_image_size_autoscaled = round(targets_diameters[number_of_black_diameter] * diameter_scale);
  t_white_border_image_size_autoscaled = round(targets_diameters[number_of_biggest_diameter] * diameter_scale);

};

public void scale_the_target()
{
  if(target_type == 0)
    { 
    circle_target_scaling();
    };
  if(target_type == 1)
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
  for (int y = 0; y < video_height; y++)
    {
      for (int x = 0; x < video_width; x++)
      {
        // Get the color stored in the pixel
        int pixelValue = video.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // filttering the brightest pixel
        if (pixelBrightness > 254)
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
};


public void calculate_hit_range()
{
  // This calculate the center betwen first and last brightest pixel
  hit_Y = (brightestY_high + brightestY_low) / 2; // X-coordinate of the brightest video pixel
  hit_X = (brightestX_high + brightestX_low) / 2; // Y-coordinate of the brightest video pixel
  hit_Y += (y_projectile_shift * diameter_scale);
  delta_X = target_diameters_center_X + correction_X - hit_X; // plus offset
  delta_Y = target_diameters_center_Y + correction_Y - hit_Y; // plus offset
  // Calculate distance from center
  center_range = sqrt((delta_X * delta_X)+ (delta_Y * delta_Y));
  center_range = round(center_range);
}

public void hit_area_test()
{
 // make border depended on projectile diameter
  //test area A
  //left up corner of area A
  side_A1X = A1X + correction_X;
  side_A1X -= (projectile_diameter * radius_scale);
  side_A1Y = A1Y + correction_Y;
  side_A1Y -= (projectile_diameter * radius_scale);
  //right down corner of area A
  side_A2X = side_A1X + A2X;
  side_A2X += (projectile_diameter * diameter_scale);// side_A1X is shiftet by radius, so its necesary to shift side_A2X with twice radius (diameter)
  side_A2Y = side_A1Y + A2Y;
  side_A2Y += (projectile_diameter * diameter_scale);
  
  if((hit_X > side_A1X) && (hit_Y > side_A1Y))
  {
    if((hit_X < side_A2X) && (hit_Y < side_A2Y))
    {
     hit_areas_ok = 1;
    }
  };
  
  //test area B
  //left up corner of area B
  side_B1X = B1X + correction_X;
  side_B1X -= (projectile_diameter * radius_scale);
  side_B1Y = B1Y + correction_Y;
  side_B1Y -= (projectile_diameter * radius_scale);
  //right down corner of area B
  side_B2X = side_B1X + B2X;
  side_B2X += (projectile_diameter * diameter_scale);
  side_B2Y = side_B1Y + B2Y;
  side_B2Y += (projectile_diameter * diameter_scale);
  
  if((hit_X > side_B1X) && (hit_Y > side_B1Y))
  {
    if((hit_X < side_B2X) && (hit_Y < side_B2Y))
    {
     hit_areas_ok = 1;
    }
  };
  
  
  
  
}



public void hit_points_calculation()
{
  
  //targets_diameters = at_airgun_cz_diameters;  // this will be in combobox targets handeler
  // radius scale make diameters to radius
  maximum_radius = int(round((targets_diameters[number_of_biggest_diameter] + projectile_diameter) * radius_scale));
  //hit_area_test();
  
  if(target_type == 0)// cirlce target
  {
    for(int i = 1; i < 11 ;i++ ) 
    {
      current_radius = (targets_diameters[i] + projectile_diameter) * radius_scale;
       if(center_range <= current_radius)
         {
         hit_points_actual = i;
         }
       if(center_range > maximum_radius)
       hit_points_actual = 0;
    }
  };
  
  
  
  if(target_type == 1) //circle square target
  {
    hit_area_test();
    if(hit_areas_ok == 1)
    {
      for(int i = 1; i < 11 ;i++ )
      {
         current_radius = (targets_diameters[i] + projectile_diameter) * radius_scale;
         if(center_range <= current_radius)
           {
           hit_points_actual = i;
           }
        if(center_range > maximum_radius)
        hit_points_actual = 0;
      }
    }
    
    if(hit_areas_ok ==0)
    {
      hit_points_actual = 0;
    }
    hit_areas_ok =0;
  };
  
  
  if(b_Shooting)
  hit_points_sum += hit_points_actual;
};



//target analyze

public void set_number_of_biggest_diameter()
{
   if(targets_diameters[1] != 0)
       {
         number_of_biggest_diameter = 1;
       }
   else for(int i = 1; i <= 9; i++) 
         { 
           //System.out.println("i: " + i);  // numbers of circles
           if(targets_diameters[i] == 0)
           {
             number_of_biggest_diameter = (i + 1);
           }
           else break;
         };
 //System.out.println("Number_of_biggest_diameter: " + number_of_biggest_diameter); 
}


public void circle_target_analyze()
{
  number_of_black_diameter = int(targets_diameters[11]);
  diameter_scale_autoscaled = (video_height - 24) / targets_diameters[number_of_biggest_diameter];  //automatic scaling for maximum diameter
  diameter_scale = diameter_scale_autoscaled; //first init diameter_scale
  radius_scale = diameter_scale / 2; //first init radius scale
  target_type = 0;
};


public void square_circle_target_analyze()
{
    float shift_X, shift_Y;
    number_of_black_diameter = int(targets_diameters[11]);

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
    System.out.println("areas_side_ratio: " + areas_side_ratio); 
    
    if (areas_side_ratio <= 1)
    {
      square_scale = (video_height - 50) / areas_height;
      //System.out.println("square_scale: " + square_scale); 

    }
    else
    {
      square_scale = (video_width - 50) / areas_width;
      //System.out.println("square_scale: " + square_scale); 
    };
    
    A1X_autoscaled = A1X * square_scale;
    A1Y_autoscaled = A1Y * square_scale;
    A2X_autoscaled = A2X * square_scale;
    A2Y_autoscaled = A2Y * square_scale;
    B1X_autoscaled = B1X * square_scale; 
    B1Y_autoscaled = B1Y * square_scale;
    B2X_autoscaled = B2X * square_scale;
    B2Y_autoscaled = B2Y * square_scale;
    CX_autoscaled = CX * square_scale;
    CY_autoscaled = CY * square_scale;
    
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
    

    shift_X = (video_width - (areas_width * square_scale)) / 2;
    shift_Y = (video_height - (areas_height * square_scale)) / 2;
    shift_Y_init = shift_Y;
    A1X += shift_X;
    A1Y += shift_Y;
    B1X += shift_X;
    B1Y += shift_Y;
    
    System.out.println("A1X: " + A1X); 
    System.out.println("A1Y: " + A1Y); 
    System.out.println("A2X: " + A2X); 
    System.out.println("A2Y: " + A2Y); 
    System.out.println("B1Y: " + B1Y); 

    
    
    target_diameters_center_X = (int)(CX + shift_X);
    target_diameters_center_Y = (int)(CY + shift_Y);  
    
    //prepare for methosd target_scale
    A1X_autoscaled = A1X;
    A1Y_autoscaled = A1Y;
    B1X_autoscaled = B1X;
    B1Y_autoscaled = B1Y;



    diameter_scale = square_scale;//first init diameter_scale 
    diameter_scale_autoscaled = diameter_scale;
    


    radius_scale = diameter_scale / 2; //first init radius scale
    target_type = 1; 
}

public void circle_target_scaling()
{
  if(last_target_scale != target_scale)
  {
    diameter_scale = diameter_scale_autoscaled * target_scale;
    radius_scale = diameter_scale / 2;
    last_target_scale = target_scale;
    t_black_center_image_size = round(t_black_center_image_size_autoscaled * target_scale);
    t_white_border_image_size = round(t_white_border_image_size_autoscaled * target_scale);
  }
}

public void square_circle_target_scaling()
{
  //this damm method i did for 5 hours...
  if(last_target_scale != target_scale)
  {
    diameter_scale = diameter_scale_autoscaled * target_scale;
    radius_scale = diameter_scale / 2;
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
}


