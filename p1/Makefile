GNS3VM_IP=192.168.56.102

ssh:
	ssh gns3@${GNS3VM_IP}

copy:
	scp -r ${PWD} gns3@${GNS3VM_IP}:/home/gns3

build_host_ahabachi:
	docker build -t host_ahabachi:p1 -f host_ahabachi .

build_router_ahabachi:
	docker build -t router_ahabachi:p1 -f router_ahabachi .

start_host_ahabachi:
	docker run -it host_ahabachi:p1 sh

start_router_ahabachi:
	docker run -it router_ahabachi:p1 sh

build: build_host_ahabachi build_router_ahabachi
