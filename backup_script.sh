#!/bin/bash

backup_dir="./backup"

echo "$db_host:$db_port:*:$db_user:$db_password" > /root/.pgpass
chmod 600 /root/.pgpass
# 生成备份文件名
backup_file="$backup_dir/db_backup_$(date +'%Y%m%d').sql"
mkdir -p $backup_dir
# 使用 pg_dump 进行备份
pg_dumpall -h $db_host -p $db_port -U $db_user> $backup_file
if [ $? -eq 0 ]; then
    echo "备份成功: $backup_file"
else
    echo "备份失败"
fi

# tar压缩包
tar -zcvf $backup_file.tar.gz $backup_file
# 删除原始文件
rm -f $backup_file
