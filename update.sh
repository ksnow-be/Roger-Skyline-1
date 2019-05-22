echo "###START OF UPDATE###" >> /var/log/update_script.log
echo "Update date:" >> /var/log/update_script.log
date >> /var/log/update_script.log
echo  >> /var/log/update_script.log
echo "LASTEST UPDATED PACKAGES:" >> /var/log/update_script.log
apt-get update && apt-get upgrade 
grep upgrade /var/log/dpkg.log >> /var/log/update_script.log
echo  >> /var/log/update_script.log
