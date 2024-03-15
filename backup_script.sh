#!/bin/bash

backup_dir="./backup"

echo "$db_host:$db_port:*:$db_user:$db_password" > /root/.pgpass
chmod 600 /root/.pgpass

# 生成备份文件名
if [ -n "$db_name" ]; then
    backup_file="$backup_dir/db_backup_${db_name}_$(date +'%Y%m%d').sql"
else
    backup_file="$backup_dir/db_backup_$(date +'%Y%m%d').sql"
fi

mkdir -p $backup_dir

# 使用 pg_dump 进行备份
if [ -n "$db_name" ]; then
    pg_dump -h $db_host -p $db_port -U $db_user -d $db_name > $backup_file
else
    pg_dumpall -h $db_host -p $db_port -U $db_user > $backup_file
fi

if [ $? -eq 0 ]; then
    echo "备份成功: $backup_file"
else
    echo "备份失败"
fi

# tar压缩包
tar -zcvf "${backup_file}.tar.gz" $backup_file

# 删除原始文件
rm -f $backup_file
