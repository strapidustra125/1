sudo docker run -d --restart always -ti -p 8080:8080 -p 29418:29418 gerritcodereview/gerrit
sudo docker run -d --restart always -p 8090:8080 -p 50000:50000 -e JAVA_OPTS=-Djenkins.install.runSetupWizard=false docker.io/jenkins/jenkins

