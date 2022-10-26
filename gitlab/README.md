### 运行镜像
```shell
docker run --name gitlab \
    -p 10443:10443 -p 10081:10081 -p 2222:22  \
    --restart always  \
    -v /data/gitlab/config:/etc/gitlab  \
    -v /data/gitlab/logs:/var/log/gitlab  \
    -v /data/gitlab/data:/var/opt/gitlab  \
    --shm-size 256m \
    -d gitlab/gitlab-ce
```
