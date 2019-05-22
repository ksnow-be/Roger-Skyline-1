# --------   Def policy to DROP   -------
iptables -P INPUT DROP
iptables -P FORWARD DROP

# --------   Accept freinds only   -------
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# --------   Drop all invalid   --------
iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
iptables -A FORWARD -m conntrack --ctstate INVALID -j DROP

# --------   SSH   --------

#	accept all
iptables -A INPUT -p tcp --dport 8822 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
#	but under 3 connections only
iptables -A INPUT -p tcp --dport 8822 -m connlimit --connlimit-above 2 -j DROP

# ---------   Port scanning protection   --------

#	10 connections in 30 min on tcp
iptables -A INPUT -p tcp -m recent --rcheck --seconds 1800 --hitcount 10 --rttl -j DROP
iptables -A INPUT -p tcp -m recent --rcheck --seconds 120 --hitcount 5 --rttl -j DROP

#	10 connections in 30 min on udp
iptables -A INPUT -p udp -m recent --rcheck --seconds 1800 --hitcount 10 --rttl -j DROP
iptables -A INPUT -p udp -m recent --rcheck --seconds 120 --hitcount 5 --rttl -j DROP

#	make new friedns on 80,443 tcp and all udp with 40 packegaes in 1 sec for NEW
iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW -m limit --limit 40/sec --limit-burst 40 -j ACCEPT
iptables -A INPUT -p udp -m conntrack --ctstate NEW -m limit --limit 40/sec --limit-burst 40 -j ACCEPT

#	10 connections with unique IP only
iptables -A INPUT -p tcp -m multiport --dports 80,443 -m connlimit --connlimit-above 10 --connlimit-mask 32 -j DROP

#	acception only reset-reset packages with 2 in sec and 2 all (SMURF PROT)
iptables -A INPUT -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/sec --limit-burst 2 -j ACCEPT
iptables -A INPUT -p icmp -m icmp --icmp-type timestamp-request -j DROP
iptables -A INPUT -p icmp -m icmp --icmp-type address-mask-request -j DROP

#	setters
iptables -A INPUT -p tcp ! --dport 8822 -m recent --set
iptables -A INPUT -p udp -m recent --set

# -------   Accept PING   -------
iptables -t filter -A INPUT -m conntrack --ctstate NEW -p icmp -j ACCEPT
