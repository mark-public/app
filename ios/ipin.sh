#!/bin/sh
TEMP_DIR=/app/appIcon/tmp/
WORK_DIR=/app/appIcon/
if [[ -z $1 ]] || [[ -z $2 ]] ; then
echo '缺少脚本执行参数,程序退出';
exit
fi
UUID_FILE_DIR=$1
FILE_NAME=$2
echo "当前处理文件：$TEMP_DIR/$UUID_FILE_DIR/$FILE_NAME"

##复制 python 脚本文件都临时目录
cd $WORK_DIR && pwd && cp ipin.py  $TEMP_DIR/$UUID_FILE_DIR/
cd $TEMP_DIR/$UUID_FILE_DIR/ && python ipin.py && mv $FILE_NAME $WORK_DIR
#清除临时文件
#cd $TEMP_DIR && rm -rf $UUID_FILE_DIR
echo "-----The end----"
