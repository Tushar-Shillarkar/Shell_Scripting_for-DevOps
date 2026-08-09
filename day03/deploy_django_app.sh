#!/bin/bash 

<< task
deploy a django app
and handle the code for errors
task

code_clone() {
	echo "cloning the django app..."
	git clone https://github.com/LondheShubham153/django-notes-app.git
	
} 

install_requirements() {
	echo "installing dependencies.."
	sudo apt-get install docker.io nginx -y
}

required_restarts() {
	sudo systemctl enable docker
	sudo systemctl enable nginx
}
deploy() {
	docker build -t notes-app .
	docker run -d -p 8000:8000 notes-app:latest
}
echo"*************** DEPLOYMENT sTRATED ******************"
if ! code_clone; then
	echo " mamu repo pehlich hai"
	cd django-notes-app
fi
install_requirements
required_restarts
deploy
echo "*************** DEPLOYMENT DONE ******************
             
         
          
        
      


