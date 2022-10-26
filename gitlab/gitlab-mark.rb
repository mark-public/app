external_url 'https://8.219.81.194:10443'
nginx['listen_port'] = 10443
gitlab_rails['gitlab_shell_ssh_port'] = 2222

#如果因为这行报错，改成false即可
letsencrypt['enable'] = false

nginx['ssl_certificate'] = "/etc/gitlab/ssl/server.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/server.key"
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
