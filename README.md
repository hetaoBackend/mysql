#### mysql 容器

容器内部配置路径: /home/work/conf
容器内部数据路径: /home/work/data
容器内部日志路径: /home/work/logs

配置模版是 conf/my-template.conf, 用户需要运行render_conf, 生成需要的配置.
readonly-mask.yaml, writable-mask.yaml 是 render_conf 需要的样例 mask 文件, 其中:

- readonly-mask.yaml: 只读mysql, 线上数据库多采用这种.
- writable-mask.yaml: 可写mysql, 建库时采用.

通常情况下，默认参数即可，用户也可根据需要自行修改.

> 历史记录请参考: https://github.com/jiweil/docker/mysql
