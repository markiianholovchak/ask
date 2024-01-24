18.184.100.115
1. docker

sudo dnf install -y docker
sudo systemctl start docker
 
sudo docker run --name=grafana -d -p 80:3000 grafana/grafana
sudo docker run --name=influxdb -d -p 8086:8086 influxdb:1.8-alpine

curl -i -X POST 'http://127.0.0.1:8086/write?db-telegraf' --data-binary "my_metric,foo=boo,host=my_host value=0.55555 234453654765879809"

sudo dnf install https://dl.influxdata.com/telegraf/releases/telegraf-1.29.2-1.x86_64.rpm

sudo dnf install stress
