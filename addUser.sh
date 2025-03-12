#!/bin/bash

# 检查是否以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "请使用 root 权限运行此脚本"
    exit 1
fi

# 读取用户名
read -p "请输入要创建的用户名: " USERNAME

# 创建用户并设置密码
useradd -m -s /bin/bash "$USERNAME"
echo "为 $USERNAME 设置密码"
passwd "$USERNAME"

# 添加用户到 sudo 组
usermod -aG sudo "$USERNAME"

# 创建 SSH 目录并设置权限
mkdir -p /home/$USERNAME/.ssh
chmod 700 /home/$USERNAME/.ssh
touch /home/$USERNAME/.ssh/authorized_keys
chmod 600 /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

echo "用户 $USERNAME 创建成功，并已授予 sudo 权限"
