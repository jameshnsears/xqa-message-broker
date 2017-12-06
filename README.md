# xqa-message-broker [![Build Status](https://travis-ci.org/jameshnsears/xqa-message-broker.svg?branch=master)](https://travis-ci.org/jameshnsears/xqa-message-broker)
* an ActiveMQ instance that provides AMQP and HTTP.

# 1. Build locally
* docker-compose -p "dev" build

# 2. Bring up
* docker-compose -p "dev" up -d

# 3. Connect
* visit ActiveMQ [http://127.0.0.1:8161/admin/](http://127.0.0.1:8161/admin/) page - admin/admin
* jconsole service:jmx:rmi:///jndi/rmi://localhost:1099/jmxrmi - admin/admin

# 4. (Optional) View ELK filebeat
* curl -u elastic:changeme -XGET 'localhost:9200/_cat/indices?v&pretty'
* curl -u elastic:changeme -XGET 'localhost:9200/filebeat-2017.10.04/_search?pretty&q=response=200'  # replace with today's YYYY.MM.DD

## 4.1. Create ELK filebeat index pattern & discover it
* visit Kibana [http://0.0.0.0:5601/](http://0.0.0.0:5601/) - elastic/changeme
* Management > Kibana Index Patterns > enter "filebeat-*" & press "Create"
* Discover > ...

## 4.2. (Optional) Create ELK filebeat dashboards
* curl -u elastic:changeme -H 'Content-Type: application/json' -XPUT 'http://0.0.0.0:9200/_template/filebeat' -d@filebeat/filebeat.template.json
* import_dashboards -user kibana -pass changeme -file beats-dashboards-5.6.2.zip
* visit [http://0.0.0.0:5601/](http://0.0.0.0:5601/) elastic/changeme

# 5. Teardown
* docker-compose -p "dev" down --rmi all -v
