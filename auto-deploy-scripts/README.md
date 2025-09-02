## Note
To execute the cron, create neccessary files and directories. Specially a log dir and adjust the paths in scripts
- weekly trigger
- configurable cron at line CRON_LINE="0 0 * * 0 cd $PWD in initcrontab.sh 

initailize the script
```bash
./initcrontab.sh
```