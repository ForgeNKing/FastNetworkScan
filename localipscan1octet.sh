#!/bin/bash
# made by ForgeN
# Save the output of the ping command to a file

parallel -j 255 ping -c 1 -W 1 192.168.20.{} ::: {1..255} >> output.txt;

# Extract only the live hosts from the ping output
grep "bytes from" output.txt | cut -d " " -f 4 | cut -d ":" -f 1 > live_hosts.txt

# Check for the openness of HTTP and HTTPS ports for each live host
while read host; do
  
  if nc -z -w 1 ${host} 80; then
    echo "Port 80 is open on host ${host}"
  else
    true
  fi

  # Use the netcat (nc) command to check if port 443 is open
  # -z flag specifies that nc should not send any data to the server
  # -w flag specifies the timeout for the connection
  if nc -z -w 1 ${host} 443; then
    echo "Port 443 is open on host ${host}"
  else
    true
  fi

done <live_hosts.txt
