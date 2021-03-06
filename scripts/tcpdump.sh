#!/bin/bash
# Tcpdump script for sniffing on available interfaces

##################################################
f_identify_device(){

# Check device
  hardw=`getprop ro.hardware`
  if [[ "$hardw" == "deb" || "$hardw" == "flo" ]]; then
    # Set interface for new Pwn Pad
    gsm_int="rmnet_usb0"
  else
    # Set interface for Pwn Phone and old Pwn Pad
    gsm_int="rmnet0"
  fi
}

##################################################
f_interface(){
  clear
  echo "Select which interface to sniff on [1-6]:"
  echo
  echo "1. eth0  (USB Ethernet adapter)"
  echo "2. wlan0  (internal Wifi)"
  echo "3. wlan1  (USB TP-Link adapter)"
  echo "4. mon0  (monitor mode interface)"
  echo "5. at0  (Use with EvilAP)"
  echo "6. $gsm_int (4G GSM connection)"
  echo
  read -p "Choice [1-6]: " interfacechoice

  case $interfacechoice in
    1) interface=eth0 ;;
    2) interface=wlan0 ;;
    3) interface=wlan1 ;;
    4) interface=mon0 ;;
    5) interface=at0 ;;
    6) interface=$gsm_int ;;
    *) f_interface ;;
  esac
}

f_savecap(){
  clear
  echo
  echo "Save packet capture to /opt/pwnix/captures/tcpdump?"
  echo
  echo "1. Yes"
  echo "2. No"
  echo
  read -p "Choice [1-2]: " saveyesno

  case $saveyesno in
    1) f_yes ;;
    2) f_no ;;
    *) f_savecap ;;
  esac
}

f_yes(){
  filename=/opt/pwnix/captures/tcpdump/tcpdump_$(date +%F-%H%M).cap
  tcpdump -l -s0 -vvv -e -xx -i $interface | tee $filename
}

f_no(){
  tcpdump -s0 -vvv -e -i $interface
}

f_identify_device
f_interface
f_savecap
