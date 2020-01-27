# docker_laravel
라즈베리파이에서 docker로 laravel 개발 환경을 하려는데 화딱지 나서 직접 만든 docker-compose.

# 사용법
docker-compose.yml 파일 위치로 이동 후 다음 명령어 실행
```bash
> docker-compose up
> # docker-compose up --build 바뀐 내용이 있다면 이렇게
```

# 구성
php-fpm + laravel / nginx / mariadb 이렇게 3개의 컨테이너가 있다.
컨테이너는 alpine Linux가 기본이고 dockerfile를 참고하면 버전을 알 수 있다(3.10, 3.11)

그림으로 나타내면 다음과 같다.
<img src="https://user-images.githubusercontent.com/38307839/73162392-074e5b00-4131-11ea-8cc1-29f25d5bf404.png" alt="photo">


app 디렉토리에는 dockerfile, laravel 파일이 있으며 php, opcache 설정을 위한 ini파일이 포함되어있다.
app.dockerfile을 보면 laravel 운용에 필요한 php 라이브러리들과 composer를 설치한다.

web 디렉토리는 nginx dockerfile과 nginx 설정을 위한 default.conf 파일이 있다.

db 디렉토리는 mariadb dockerfile과 db 첫 세팅을 위한 run.sh, mysql 데이터 디렉토리가 있다. run.sh를 이용해서 첫 mariadb 데이터 초기화를
해도 되지만 도커 볼륨을 이용해서 mysql 디렉토리를 이용하는 쪽으로 했다.

# 주의점
docker laravel 환경을 구성하면서 주의할 점들이 몇 가지 있다.

1. 개인적으로 yml파일은 C언어보다 민감한 문법을 가지고 있으니 특히 띄어쓰기, TAB, 공백에 유의하여 쓰자.

2. 라즈베리파이의 포트포워딩, default.conf 설정, EXPOSE, 컨테이너 IP 등 포트에 관한 설정이 까다롭다. 어디 포트를 뚫고 공유를 해야하는지
생각을 잘 해야한다. 이 덕분에 이미지를 몇 번 지웠다 생성했는지 눈물이 난다.

3. 앞서 말했듯이 db 첫 세팅을 할 때 run.sh을 이용해서 초기화 해도 되고 도커 볼륨을 이용해서 mysql 디렉토리를 이용해도 된다. 나는 도커
볼륨을 이용했다. 참고로 mysql 디렉토리는 처음 mysql db를 생성했을 때의 데이터이다.

단독으로 db container를 사용하려면 다음과 같이 명령어를 주면 된다. run.sh를 이용 할 경우 db.dockerfile에서 마지막 두 줄은 주석 해제 해야한다.
```bash
> docker run -e MYSQL_DATABASE=/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root_password -e MYSQL_USER=user -e MYSQL_PASSWORD=password -it [DB_CONATINER]
```
