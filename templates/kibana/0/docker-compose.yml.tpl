kibana-vip:
  ports:
  - "${public_port}:80"
  restart: always
  tty: true
  image: rancher/load-balancer-service
  links:
  - nginx-proxy:kibana5
  stdin_open: true
nginx-proxy-conf:
  image: rancher/nginx-conf:v0.2.0
  command: "-backend=rancher --prefix=/2015-07-25"
  labels:
    io.rancher.container.hostname_override: container_name
nginx-proxy:
  image: rancher/nginx:v1.9.4-3
  volumes_from:
    - nginx-proxy-conf
  labels:
    io.rancher.container.hostname_override: container_name
    io.rancher.sidekicks: nginx-proxy-conf,kibana5
  external_links:
    - ${elasticsearch_source}:elasticsearch
kibana5:
  restart: always
  tty: true
  image: docker.elastic.co/kibana/kibana:5.5.2
  net: "container:nginx-proxy"
  stdin_open: true
  environment:
    ELASTICSEARCH_URL: "http://elasticsearch:9200"
  labels:
io.rancher.container.hostname_override: container_name
