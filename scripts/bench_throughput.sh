hostname=${1:-localhost}

sbin="`dirname "$0"`"
sbin="`cd "$sbin"; pwd`"

echo "Benchmarking server at $hostname"
for i in 1 2 4 8 16 32 64; do
  for mix in "0.0-0.0-1.0-0.0" "0.5-0.5-0.0-0.0" "0.34-0.33-0.33-0.0"; do
    ssh -o StrictHostKeyChecking=no $hostname "nohup /home/ec2-user/log-store/build/server/bin/server >/dev/null 2>/home/ec2-user/throughput-${mix}-${i}.log &"
    sleep 5
    $sbin/../build/bench/bin/lsbench -b throughput-${mix} -n $i -h $hostname ~/tpch
    ssh -o StrictHostKeyChecking=no $hostname "killall server"
  done
done
