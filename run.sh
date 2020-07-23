#!/bin/sh
set -u
set -e

ROOT=/tpcc-mysql
DATA=tpcc
W=1
L=30

while getopts "h:u:p:d:w:" opt; do
   case $opt in
      h)
         HOST=$OPTARG
         ;;
      u)
         USER=$OPTARG
         ;;
      p)
         PASS=$OPTARG
         ;;
      d)
         DATA=$OPTARG
         ;;
      w)
         W=$OPTARG
         ;;
      l)
         L=$OPTARG
         ;;
   esac
done
shift $((OPTIND-1))

case $1 in
   init)
      echo "==> init"
      echo "    mysql://${HOST}/${DATA}"
      mysql -u${USER} -p${PASS} -h${HOST} -e "CREATE DATABASE ${DATA};"
      mysql -u${USER} -p${PASS} -h${HOST} ${DATA} < ${ROOT}/create_table.sql
      mysql -u${USER} -p${PASS} -h${HOST} ${DATA} < ${ROOT}/add_fkey_idx.sql
      ;;
      
   load)
      echo "==> load"
      echo "    mysql://${HOST}/${DATA}"
      echo "    ${W} warehouse"
      ${ROOT}/tpcc_load -h${HOST} -d${DATA} -u${USER} -p${PASS} -w${W}
      ;;

   run)
      echo "==> run"
      echo "    mysql://${HOST}/${DATA}"
      echo "    ${W} warehouse"
      ${ROOT}/tpcc_start -h${HOST} -d${DATA} -u${USER} -p${PASS} -w${W} -c4 -r5 -l${L}
      ;;

   help)
      echo "Usage:"
      echo "docker run -it radondb/tpcc-mysql -h HOST -u USER -p PASS -d DATA init|load|run|help"  
esac
