@load base/frameworks/notice

#Create a notice with Mqtt::Subscribe
export {
    redef enum Notice::Type += {
        Mqtt::Subscribe
    };
}


event packet_contents(c: connection, contents: string){
	#Checks to see if the port is 1883 for the MQTT protocol
	if(c$id$resp_p == 1883/tcp){
	    #Setting up local variables to be used.
		local myvector =  vector();
		local currentpos = 0;
		local lengthpos = 1;
		local myBool = 0;
		
		#For loop to go through every byte of the packet.
		for ( a in contents){
		    #Puts the byte in a vector
			myvector[currentpos] = a;
			
			#Checks to see if the current position is a length value
			if (currentpos == lengthpos){
			
			    #Saves the length in a variable
				local length = bytestring_to_count(myvector[lengthpos]);
				
				#Create new variable where the next length value should be
				lengthpos = length + 2 + lengthpos;
				
				#If the byte before this was a subscribe message, set a boolean flag
				if (bytestring_to_count(myvector[currentpos-1]) == 130){
					myBool = 1;
				}
			}
			
			#If this is a subscribe packet check the current value
			if(myBool == 1){
			
			    #If the value is equal to #, create an alert
				if(a == "#"){
					NOTICE([$note=Mqtt::Subscribe,
	                $msg=fmt("%s attempts to subscribe to all topics.", c$id$orig_h)]);
	                
	                #No need to alert twice for this packet, if the sign is found again
					myBool = 0;
				}
			}
			
			#If we go through the entire packet, then reset the boolean variable
			if(currentpos == lengthpos){
				myBool = 0;
			}
			
			#Moving onto next byte
			currentpos += 1;
		}
	}
}
