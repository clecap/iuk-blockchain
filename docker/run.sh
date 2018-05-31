docker build -t iuk-dockchain .
docker run --net=host -it -p 30300:30300 -p 8540:8540 -p 8180:8180 -p 8450:8450 iuk-dockchain