#!/bin/bash


wget http://ubuntu-cloud.archive.canonical.com/ubuntu/dists/precise-updates/havana/main/binary-i386/Packages.gz
mkdir /var/spool/apt-mirror/mirror/ubuntu-cloud.archive.canonical.com/ubuntu/dists/precise-updates/havana/main/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/ubuntu-cloud.archive.canonical.com/ubuntu/dists/precise-updates/havana/main/binary-i386/



wget http://mirrors.sohu.com/ubuntu/dists/precise/main/binary-i386/Packages.gz
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise/main/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise/main/binary-i386/


wget http://mirrors.sohu.com/ubuntu/dists/precise/universe/binary-i386/Packages.gz 
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise/universe/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise/universe/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise/restricted/binary-i386/Packages.gz 
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise/restricted/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise/restricted/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise/multiverse/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise/multiverse/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise/multiverse/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise-security/universe/binary-i386/Packages.gz
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-security/universe/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-security/universe/binary-i386/
   
wget http://mirrors.sohu.com/ubuntu/dists/precise-security/main/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-security/main/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-security/main/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise-security/multiverse/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-security/multiverse/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-security/multiverse/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise-security/restricted/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-security/restricted/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-security/restricted/binary-i386/

 
wget http://mirrors.sohu.com/ubuntu/dists/precise-updates/universe/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-updates/universe/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-updates/universe/binary-i386/

 
wget http://mirrors.sohu.com/ubuntu/dists/precise-updates/main/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-updates/main/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-updates/main/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise-updates/multiverse/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-updates/multiverse/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-updates/multiverse/binary-i386/

 
wget http://mirrors.sohu.com/ubuntu/dists/precise-updates/restricted/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-updates/restricted/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-updates/restricted/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise-proposed/universe/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-proposed/universe/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-proposed/universe/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise-proposed/main/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-proposed/main/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-proposed/main/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise-proposed/multiverse/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-proposed/multiverse/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-proposed/multiverse/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise-proposed/restricted/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-proposed/restricted/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-proposed/restricted/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise-backports/universe/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-backports/universe/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-backports/universe/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise-backports/main/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-backports/main/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-backports/main/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise-backports/multiverse/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-backports/multiverse/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-backports/multiverse/binary-i386/
 
wget http://mirrors.sohu.com/ubuntu/dists/precise-backports/restricted/binary-i386/Packages.gz  
mkdir /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-backports/restricted/binary-i386/
mv Packages.gz /var/spool/apt-mirror/mirror/mirrors.sohu.com/ubuntu/dists/precise-backports/restricted/binary-i386/
