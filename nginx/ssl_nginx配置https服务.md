## SSL自签证书+Nginx配置https服务

###  一、SSL 证书生成

首先cd进入nginx的conf目录(也可以是任意目录，后续配置nginx ssl的时候指定为你自己的路径即可）

```shell
cd /opt/nginx/conf
#1.执行如下命令生成一个key
/opt/nginx/conf $ openssl genrsa -des3 -out ssl.key 2048
Generating RSA private key, 2048 bit long modulus
..........................+++
......+++
e is 65537 (0x10001)

##然后他会要求你输入这个key文件的密码。不推荐输入。因为以后要给nginx使用。每次reload nginx配置时候都要你验证这个PAM密码的。
由于生成时候必须输入密码。你可以先设置一个，后续再删掉
Enter pass phrase for ssl.key: (输入一个密码，如12345678）
Verifying - Enter pass phrase for ssl.key:（再输入一次密码）

##2.下面操作删除ssl.key的密码
/opt/nginx/conf $ mv ssl.key ssl_pwd.key    （重命名原来的key文件名称）
/opt/nginx/conf $ openssl rsa -in ssl_pwd.key -out ssl.key （这步操作删除key文件的密码）
Enter pass phrase for ssl_pwd.key: (输入第一步设置的密码)
writing RSA key
/opt/nginx/conf $ rm ssl_pwd.key  (删除原来带密码的key,可不操作）

##3、根据这个key文件生成证书请求文件（以上命令生成时候要填很多东西 一个个看着写吧（可以随便，毕竟这是自己生成的证书，注意Common Name必须填写服务器的域名或ip）
/opt/nginx/conf $ openssl req -new -key ssl.key -out ssl.csr
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]: CN
State or Province Name (full name) [Some-State]:Anhui
Locality Name (eg, city) []:Hefei
Organization Name (eg, company) [Internet Widgits Pty Ltd]:TEST
Organizational Unit Name (eg, section) []: test
Common Name (eg, YOUR name) []:192.168.17.30
Email Address []: (不用填写，直接回车）
Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []: (不用填写，直接回车）
An optional company name []: (不用填写，直接回车）

##最后根据这2个文件生成crt证书文件（这里365是证书有效期, 推荐3650，嫌太少了可以再加个0,这里的单位是天，3650即可10年，正常情况足够了，即使不够了后续也还可以重新生成证书，替换老的证书的即可。）
/opt/nginx/conf $ openssl x509 -req -days 3650 -in ssl.csr -signkey ssl.key -out ssl.crt
Signature ok
subject=/C=CN/ST=Anhui/L=Hefei/O=TEST/OU=test/CN=192.168.17.30/emailAddress=
Getting Private key

##最后使用ls 可以查看到生成的三个证书文件（配置nginx最后使用到的文件是key和crt文件）
/opt/nginx/conf $ ls -lrt ssl*
-rw-r--r-- 1 weblogic weblogic 1675  8月 26 16:51 ssl.key
-rw-r--r-- 1 weblogic weblogic 1054  8月 26 16:52 ssl.csr
-rw-r--r-- 1 weblogic weblogic 1302  8月 26 16:52 ssl.crt
```



### 二、nginx配置

```nginx
server {
        access_log  logs/localhost-access.log  main;
        error_log   logs/localhost-error.log  error;
        listen   443 ssl;
        server_name 192.168.17.30;
        ssl_certificate  /opt/nginx/conf/ssl.crt;
        ssl_certificate_key  /opt/nginx/conf/ssl/ssl.key;
        ssl_session_timeout 5m;
        ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
        ssl_prefer_server_ciphers on;
       
      	location /{
      		root html;
      		index index.html;
      	}
 }
```




