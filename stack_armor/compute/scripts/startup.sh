#!/bin/bash
apt-get update
apt-get install -y nginx curl
gcloud storage cp gs://toba-project-466015-html-content/index.html /var/www/html/index.html
systemctl restart nginx
