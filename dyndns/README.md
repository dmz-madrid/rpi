## Dynamic dns update

# no-ip dynamic updater (ddupdate.sh)

This shell script replaces the Dynamic Update Client (DUC) for noip.com: [No-IP DUC](https://www.noip.com/support/knowledgebase/installing-the-linux-dynamic-update-client/ "Howto install DUC on Linux ")\
Based on ddnss.de [script](https://ddnss.de/info.php "CRON & Bash Script") and this repo from [theonemule](https://github.com/theonemule/no-ip) 
I wanted to use a simpler script(since the DUC from No-IP requires `make install` and edit config files) and just use a crontab to run it from time to time. 

1: Download the file and edit the parameters
    
    wget -qO ddupdate.sh https://raw.githubusercontent.com/dmz-madrid/rpi/master/dyndns/ddupdate.sh
    nano ddupdate.sh
    
2: Copy the file to `/usr/bin`

    sudo cp ddupdate.sh /usr/sbin/ddupdate.sh
    
3: Create log files and give read/write permissions to all users

    sudo mkdir /var/log/no-ip
    sudo touch /var/log/no-ip/no-ip.log
    sudo touch /var/log/no-ip/oldip.log
    sudo chmod u+rw,g+rw,o+rw /var/log/no-ip/*
   
4: Create root crontab (use nano editor) to execute each 10 minutes:
    
    sudo su
    crontab -e
    */10 * * * * /usr/sbin/ddupdate.sh >/dev/null 2>&1
    /
    ├── /
    ├── Gemfile.lock
    ├── usr
    │   └── sbin
    │       └── no-ip.sh
    └── var
        └── log
            └── no-ip
                └── no-ip.log  
                └── oldip.log  
