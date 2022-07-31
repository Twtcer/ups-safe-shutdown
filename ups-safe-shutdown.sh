#!/bin/bash

target_ip=192.168.123.1
failure_count=3
shutdown_failure_count_threshold=15

while :
do
  ping -c 1 $target_ip &> /dev/null
  if [ $? -eq 0 ]; then
    ((failure_count=0))
  else
    ((failure_count++))
  fi
  sleep 10s
  if [ $failure_count -eq $shutdown_failure_count_threshold ]; then
    /sbin/shutdown -hP now
	sendMsg
    break
  fi
done

sendMsg(){
	curl -H "Content-Type: application/json" -X POST -d '{"topic":"pve","token":"e5145cdd4e4442d29e7d9dc0944ca94c","title":"断电提醒","content":"## 时间： \r\n## 断电了1111","template":"markdown","channel":"wechat"}' "https://www.pushplus.plus/api/send"
}

exit 0
