GNS3VM_IP=192.168.56.102

ssh:
	ssh gns3@${GNS3VM_IP}

copy:
	scp -r ${PWD} gns3@${GNS3VM_IP}:/home/gns3

build__bbrahim_host:
	docker build -t host_bbrahim-1:p1 -f host_bbrahim-1 .

build__bbrahim_router:
	docker build -t routeur_bbrahim:p1 -f routeur_bbrahim .

start__bbrahim_host:
	docker run -it host_bbrahim-1:p1 sh

start__bbrahim_router:
	docker run -it routeur_bbrahim:p1 sh

build: build__bbrahim_router build__bbrahim_host