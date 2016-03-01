image=mysql_lenny
docker build -t $image .
docker run -ti $image bash