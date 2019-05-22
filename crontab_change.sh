SHASUM1=$(md5sum /etc/crontab | cut -d ' ' -f1)
SHASUM2=$(md5sum /home/lol/mirror_cron | cut -d ' ' -f1)

if [ "$SHASUM1" != "$SHASUM2" ] ; 
then
	echo "< --- Cron has been modified! --- >" | ssmtp -v -s wildchild1088@gmail.com
	cp /etc/crontab /home/lol/mirror_cron
else
	echo "Crontab is not modified!"
fi

exit 0
