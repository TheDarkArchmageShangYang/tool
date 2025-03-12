#!/bin/bash

# 确保脚本以 root 权限运行
if [ "$(id -u)" -ne 0 ]; then
    echo "请使用 root 权限运行此脚本"
    exit 1
fi

# 创建 SSH 配置目录（如果不存在）
mkdir -p /etc/ssh/sshd_config.d

# 创建自定义 SSH 配置文件
CONFIG_FILE="/etc/ssh/sshd_config.d/fzchen.conf"

echo "Port 2220
PermitRootLogin yes
PasswordAuthentication no
PubkeyAuthentication yes
" > "$CONFIG_FILE"

# 设置正确的权限
chmod 644 "$CONFIG_FILE"

# 允许防火墙打开端口 2220（如有防火墙）
if command -v ufw &> /dev/null; then
    ufw allow 2220/tcp
    echo "已在 UFW 防火墙中开放 2220 端口"
fi

# 重新加载 SSH 服务
systemctl restart ssh

echo "SSH 配置已更新(存储于 $CONFIG_FILE):"
echo "- 端口改为 2220"
echo "- 禁用密码登录，只允许密钥登录"
echo "- 允许 root 账户直接 SSH 登录"
echo "请使用 'ssh -p 2220 用户名@服务器IP' 进行连接"
