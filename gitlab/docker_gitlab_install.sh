#!/bin/bash
[ ! -d /home/gitlab ] && mkdir /home/gitlab
cd /home/gitlab

cat > docker-compose-gitlab.yml << 'EOF'
version: '3.6'
services:
  gitlab:
    container_name: gitlab
    image: gitlab/gitlab-ce:latest
    restart: always
    hostname: 'gitlab.myzk.xyz'
    environment:
      TZ: 'Asia/Shanghai'    
    ports:
      - "0.0.0.0:10081:10081"
      - "0.0.0.0:10443:10443"
      - "0.0.0.0:2222:22"
    volumes:
      - /data/gitlab/config:/etc/gitlab:rw
      - /data/gitlab/logs:/var/log/gitlab:rw
      - /data/gitlab/data:/var/opt/gitlab:rw
    shm_size: '256m'
    logging:
      driver: "json-file"
      options:
        max-size: "100M"
        max-file: "3"
    deploy:
      resources:
         limits:
            cpus: "4.00"
            memory: 8G
         reservations:
            memory: 2G
EOF

echo "正在部署...."
docker-compose -f docker-compose-gitlab.yml up -d
echo "容器创建完成，正在初始化,等待一分钟..."
sleep 60

##-----修改gitlab.rb配置-----
##进入gitlab配置目录
cd /data/gitlab/config
##备份原配置
cp gitlab.rb gitlab.rb.bak

##重新创建文件
cat > gitlab.rb << 'EOF'
external_url 'https://gitlab.myzk.xyz:10443'
nginx['listen_port'] = 10443
gitlab_rails['gitlab_shell_ssh_port'] = 2222

#如果因为这行报错，改成false即可
letsencrypt['enable'] = false

nginx['ssl_certificate'] = "/etc/gitlab/ssl/gitlab.pem"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/gitlab.key"
nginx['ssl_ciphers'] = "ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384"
nginx['ssl_prefer_server_ciphers'] = "on"
nginx['ssl_protocols'] = "TLSv1.1 TLSv1.2 TLSv1.3"
nginx['ssl_session_cache'] = "shared:SSL:10m"
nginx['redirect_http_to_https'] = true
nginx['redirect_http_to_https_port'] = 10443
nginx['client_max_body_size'] = '250m'
nginx['worker_processes'] = 4

gitlab_rails['gitlab_email_enabled'] = true
gitlab_rails['gitlab_email_from'] = '503001318@qq.com'
gitlab_rails['gitlab_email_display_name'] = 'gitlab'
gitlab_rails['gitlab_email_reply_to'] = '503001318@qq.com'
gitlab_rails['gitlab_email_subject_suffix'] = '[gitlab]'
gitlab_rails['smtp_enable'] = true
gitlab_rails['smtp_address'] = "smtp.qq.com"
gitlab_rails['smtp_port'] = 465
gitlab_rails['smtp_user_name'] = "503001318@qq.com"
gitlab_rails['smtp_password'] = "ouwolliouwtsbiff"
gitlab_rails['smtp_domain'] = "smtp.qq.com"
gitlab_rails['smtp_authentication'] = "login"
gitlab_rails['smtp_enable_starttls_auto'] = true
gitlab_rails['smtp_tls'] = true
EOF

##-----配置证书--------
echo "正在配置证书..."
mkdir -p /data/gitlab/config/ssl
cd /data/gitlab/config/ssl
wget http://markabc.xyz/zk/gitlab.pem -O gitlab.pem
wget http://markabc.xyz/zk/gitlab.key -O gitlab.key

##----重新配置gitlab-----
echo "重新配置gitlab中..."
docker exec -it gitlab gitlab-ctl reconfigure
##替换 nginx中的 http监听的端口,否则http和 https 监听同一个端口，存在冲突；
sed -i 's/10443;/10081;/g' /data/gitlab/data/nginx/conf/gitlab-http.conf

##---重启gitlab------
echo "正在停止gitlab服务...."
docker exec -it gitlab gitlab-ctl stop
echo "正在启动gitlab服务...."
docker exec -it gitlab gitlab-ctl start

##--打印root用户密码
echo "Gitlab安装完成..."
echo "访问地址: http://gitlab.myzk.xyz:10081/  或 https://gitlab.myzk.xyz:10443/"

echo "管理员用户名：root初试密码如下，请尽快登录修改密码"
docker exec -it gitlab grep 'Password:' /etc/gitlab/initial_root_password

echo "全部结束，祝你使用愉快...."
echo ""
echo ""
