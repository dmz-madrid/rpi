## Dynamic dns update

# no-ip dynamic updater (no-ip-updater.sh)

This shell script replaces the Dynamic Update Client (DUC) for [No-IP](https://www.noip.com/support/knowledgebase/installing-the-linux-dynamic-update-client/ "No-IP: How to install DUC on Linux ")\
Based on ddnss.de [script](https://ddnss.de/info.php "CRON & Bash Script") and this repo from [theonemule](https://github.com/theonemule/no-ip)\
I wanted to use a simpler script and just use a crontab to run it from time to time. Since the DUC from No-IP requires `make install` and edit config files, this seems a better option for me.

# usage (shell script)

1: Download the file and edit the parameters
    
    wget -qO no-ip-updater.sh https://raw.githubusercontent.com/dmz-madrid/rpi/master/dyndns/no-ip-updater.sh
    nano no-ip-updater.sh
    
2: Copy the file to `/usr/bin`

    sudo cp no-ip-updater.sh /usr/sbin/no-ip-updater.sh
    
3: Create log files and give read/write permissions to all users

    sudo mkdir /var/log/no-ip
    sudo touch /var/log/no-ip/no-ip.log
    sudo touch /var/log/no-ip/oldip.log
    sudo chmod u+rw,g+rw,o+rw /var/log/no-ip/*
   
4: Create root crontab (use nano editor) to execute each 10 minutes:
    
    sudo su
    crontab -e
    */10 * * * * /usr/sbin/no-ip-updater.sh >/dev/null 2>&1
    
5: The final folder tree should look like this

    root
    ├── usr
    │   └── sbin
    │       └── no-ip-updater.sh
    └── var
        └── log
            └── no-ip
                └── no-ip.log  
                └── oldip.log  
# usage (python script)

