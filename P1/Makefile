GNS3VM_IP=192.168.56.102

ssh:
	ssh gns3@${GNS3VM_IP}

copy:
	scp -r ${PWD} gns3@${GNS3VM_IP}:/home/gns3

build__obeaj_host:
	docker build -t obeaj_host:p1 -f _obeaj-1_host .

build__obeaj_router:
	docker build -t obeaj_router:p1 -f _obeaj-2 .

start__obeaj_host:
	docker run -it obeaj_host:p1 sh

start__obeaj_router:
	docker run -it obeaj_router:p1 sh

build: build__obeaj_router build__obeaj_host


clean:
	docker image rm obeaj_host:p1   || true
	docker image rm obeaj_router:p1 || true