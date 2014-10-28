/*
This udp.pde is part of HomeLESS: The Bubbles TD.

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


import hypermedia.net.*;    // import UDP library

UDP udp;  // define the UDP object (sets up)

String s_Destination_IP_addres = "127.0.0.1";
String s_Source_IP_addres = "127.0.0.1";

int i_Destination_port = 56789;
int i_Source_port = 58618;
//int i_resolution_X = 640;
//int i_resolution_Y = 480;


// void receive( byte[] data ) {            // <-- default handler
void receive( byte[] data, String ip, int port )
{  // <-- extended handler
  // get the "real" message =
  String s_HIP_message = new String( data );
  String s_HIP_message_header = s_HIP_message.substring(0,2);
  String s_HIP_message_ID = s_HIP_message.substring(3,7);
  String s_HIP_message_SID = s_HIP_message.substring(8,16);
  //println( "s_HIP_message_header: " + s_HIP_message_header);
  //println( "s_HIP_message_ID: " + s_HIP_message_ID);
  //println( "s_HIP_message_SID: " + s_HIP_message_SID);
  
  //check for HIP message
  if(s_HIP_message_header.equals("HA"))
  {
    
    //check for HIP message type
    if(s_HIP_message_ID.equals("0101"))
      {
        String[] parts = split(s_HIP_message, "-");
        //String[] parts = split(message, "&");
        int sentX = int(parts[3]);
        int sentY = int(parts[4]);    //"24" -> 24
        println( "sentX: " +sentX);
        println( "sentY: " +sentY);
        
         //reset the program
        if(i_bubble_left == 0)
        {
          shoot_the_reset(sentX + i_area_of_interest_offset_X, sentY + i_area_of_interest_offset_Y);
        };
        
        shoot_the_bubble(sentX + i_area_of_interest_offset_X, sentY + i_area_of_interest_offset_Y);
        
        println( "i_bubble_left: " + i_bubble_left);
       
        
        //ellipse(sentX + i_area_of_interest_offset_X, sentY + i_area_of_interest_offset_Y, 5, 5);
        //stroke(0);   
        //line(width-sentX , sentY , random(0, 480), 0);
        //ellipse(sentX, sentY, 5, 5);
        //println( "received message from Hit Analyzer: ");
      }
    if(s_HIP_message_ID.equals("0199"))
    {
      shoot_the_bubble(0, 0); // this hit position is out of area of interest
    }
    //println( "received message from Hit Analyzer: ");
  }
}
 
