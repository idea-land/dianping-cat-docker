dianping-cat-docker
==========================================================
## generate and set database password
* for windows(dos):
```
for /f %i in ( 'openssl rand -base64 12') do @set DATABASE_PASSWORD=%i&set DATABASE_PASSWORD
```
* for linux:
```
export DATABASE_PASSWORD=$(openssl rand -base64 12) && echo DATABASE_PASSWORD=$DATABASE_PASSWORD
```
**DATABASE_PASSWORD should from base64 char

## startup containers
* docker-compose way:
```
docker-compose up -d
```

* docker stack way:
```
docker-compose config | docker deploy -c - cat
```
## check startup logs
` docker-compose logs -f `

## visit app: http://127.0.0.1:18080/cat/r 

