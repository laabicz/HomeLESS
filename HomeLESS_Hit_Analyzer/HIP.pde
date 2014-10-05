/*
This HIP.pde is part of HomeLESS Hit Analyzer.

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


public boolean b_hip_enable = false, b_hit_sent = false;

public String s_Destination_IP_address;// = "127.0.0.1";
public String s_Source_IP_address, s_SID;
String s_HIP_message;    // the message to send
public int i_Destination_port;// = 58618;
public int i_Source_port;


void HIP_setup()
{
  String[] hip_ini_file_contain = loadStrings("hip.ini");

  
  //enable/disable HIP, line 0
  String[] hip_ini_file_contain_parts = split(hip_ini_file_contain[1], "=");
  if(Integer.valueOf(hip_ini_file_contain_parts[1].trim()).intValue() == 1)
    {
      b_hip_enable = true;
    };
  
  
 if(b_hip_enable)
   {

     // settings source, line 3,4,5
     hip_ini_file_contain_parts = split(hip_ini_file_contain[4], "="); //source address
     s_Source_IP_address = hip_ini_file_contain_parts[1].trim();
     hip_ini_file_contain_parts = split(hip_ini_file_contain[5], "="); //source port
     i_Source_port = Integer.valueOf(hip_ini_file_contain_parts[1].trim()).intValue();
     hip_ini_file_contain_parts = split(hip_ini_file_contain[6], "="); //SID
     s_SID = hip_ini_file_contain_parts[1].trim(); 
     udp = new UDP( this, i_Source_port, s_Source_IP_address );
     
     // settings destination, line 8,9
     hip_ini_file_contain_parts = split(hip_ini_file_contain[9], "="); //source address
     s_Destination_IP_address = hip_ini_file_contain_parts[1].trim();
     hip_ini_file_contain_parts = split(hip_ini_file_contain[10], "="); //source port
     i_Destination_port = Integer.valueOf(hip_ini_file_contain_parts[1].trim()).intValue();
     
     // HIP status info
     System.out.println("\nHIP enabled");
     println("  - Listenig on adress: " + s_Source_IP_address +", port: " + i_Source_port + ", SID: " + s_SID);
     println("  - Sending to adress: " + s_Destination_IP_address +", port: " + i_Destination_port + "\n");
     s_HIP_message = "HA-" + s_SID + "-0200-Hello world!";
     udp.send( s_HIP_message, s_Destination_IP_address, i_Destination_port );
   }
 else System.out.println("\nHIP disabled \n");
}


void send_hit_position()
{
   if(b_hip_enable && b_Hit_detected ) // normal style
     {
        
       
        // formats the message for Pd
        //hit, unremaped:
        s_HIP_message =  "HA-" + s_SID + "-0100-" + s_hit_X_temp + "-" + s_hit_Y_temp + "-" + String.valueOf(nf(hit_points_actual,2)) + "-" +s_time_of_hit_detection_relative;

        if(b_monoscope_synchronization_enabled)//remaped for synchronization with 3th party aplications
          {
            if(hit_areas_ok == 1)
              {
                float f_hit_X_temp, f_hit_Y_temp;
                //println("\nHit position remaped");
                f_hit_X_temp = map(f_hit_X, side_A1X, side_B2X, f_hit_remap_range_min_X, f_hit_remap_range_max_X);
                f_hit_Y_temp = map(f_hit_Y, side_A1Y, side_B2Y, f_hit_remap_range_min_Y, f_hit_remap_range_max_Y);
                s_hit_X_temp = (nf(f_hit_X_temp,4,1)).substring(0,4) + "." + (nf(f_hit_X_temp,4,1)).substring(5);  //replace "," by "."
                s_hit_Y_temp = (nf(f_hit_Y_temp,4,1)).substring(0,4) + "." + (nf(f_hit_Y_temp,4,1)).substring(5);
                //println("New hit X position: " + s_hit_X_temp);
                //println("New hit Y position: " + s_hit_Y_temp);
                s_HIP_message =  "HA-" + s_SID + "-0101-" + s_hit_X_temp + "-" + s_hit_Y_temp + "-" +s_time_of_hit_detection_relative;
              }
            else
              {
                //println("Hit position is out of range.");
                s_HIP_message =  "HA-" + s_SID + "-0199-Hit position is out of range.";
              }
          };
        
        // send the message
        udp.send( s_HIP_message, s_Destination_IP_address, i_Destination_port );
        println("\nSent: \"" + s_HIP_message + "\" on "  + s_Destination_IP_address + ", port: " + i_Destination_port);
     }
}

