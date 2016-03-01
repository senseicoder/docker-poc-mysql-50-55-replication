image=mysql_jessie
docker build -t $image .
docker run -ti $image bash