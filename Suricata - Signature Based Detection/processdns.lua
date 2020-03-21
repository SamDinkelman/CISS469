--This function will just intiate the script, and will grab the payload of the packet.
function init (args)
    local needs = {}
    needs["payload"] = tostring(true)
    return needs
end

--The rest of my code is contained in this function. Which will return a 1
--if the entropy is greater then 3 and at least 85% of the max entropy for that sting. 
function match(args)
    a = tostring(args["payload"])
    
    --Check to see if there is anything in the payload
	if #a > 0 then
	   domain = ""
	   
	   --Go through each of the characters to only keep alphanumeric characters and
	   --the minus sigh, and put into the variable domain.
        for t in a:gmatch"." do
	        if string.match(t, "%a") then 
		        domain = domain .. t
	        elseif string.match(t, "-") then 
	            domain = domain .. t
	        end
        end
    
	    entropy = 0.0
		nodup = ""
		
		--Go through each character in the domain, and create a string that conatins
		--only one of each letter from the domain, and store in the variable nodup.
		for f in domain:gmatch"." do
		    if (string.match(nodup, f)) then
		    else
			    nodup = nodup .. f
		    end 
		end
		maxentropy = math.log(domain:len(), 2)
		
		--This loop will go through each character in the nodup string, and count
		--how many times the character appears in the original domain. It will then
		--calculate the probability of the character in the domain name. It then 
		--uses this to caclulate the entropy by taking the log of all of these probabilities,
		--and adding them to each other.
	    for d in nodup:gmatch"." do
    		count = 0
            _, count = domain:gsub(d, "")
        	prob = count/domain:len()
		    entropy = entropy + (prob*math.log(prob, 2))*-1
        end
    
        --This just tells the rule to alert if the entropy is greater then 3, and
        --the percent of entopy is at least 85% of the max.
	    if (entropy > 3) then
			percent = (entropy/maxentropy)
			if (percent > 0.85) then
			    return 1
			else
			    return 0
			end
		else
			return 0
        end
	return 0
    end
return 0
end
return 0