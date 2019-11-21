### Instructions:
When first up jenkins master go to Manage jenkins -> Configuration system -> Cloud -> Kubernetes -> Pod Templates -> Containers -> Container template -> Working directory and delete content
https://gitlab.com/rocha.public/cursos/jenkins-em-larga-escala/wikis/home

###PreReq:  
create file ./ssh/.password and put password for using users config um /groovy/credentials.groovy configuration

Extract plugin list:  
http://<JENKINS_URL>/script  

Jenkins.instance.pluginManager.plugins.each{
  plugin ->
    println ("${plugin.getShortName()}:${plugin.getVersion()}")
}


awk -v prefix="compile 'org.jenkins-ci.plugins:" -v postfix="'" '{print prefix $0 postfix}' plugins.txt > dependencies.txt

