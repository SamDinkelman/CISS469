@load base/frameworks/notice

module DNS;

#Sets up the Notice alert as DNS::Exfiltration
export {
    redef enum Notice::Type += {
        DNS::Exfiltration
    };
}

event dns_request (c: connection, msg: dns_msg, query: string, qtype: count, qclass: count){
    #Check to see if the query is bigger then 52 characters, if so, create alert with the parameters from the connection
    if (|query| > 52){
        NOTICE([$note=DNS::Exfiltration,
        $msg=fmt("Long Domain. Possible DNS exfiltration/tunnel by  %s Offending domain name: %s", c$id$resp_h, query )]);
    }
}
