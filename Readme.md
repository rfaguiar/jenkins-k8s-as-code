

###PreReq:  
create file ./ssh/.password and put password for using users config um /groovy/credentials.groovy configuration

Extract plugin list:  
http://<JENKINS_URL>/script  

Jenkins.instance.pluginManager.plugins.each{
  plugin ->
    println ("${plugin.getShortName()}:${plugin.getVersion()}")
}


awk -v prefix="compile 'org.jenkins-ci.plugins:" -v postfix="'" '{print prefix $0 postfix}' plugins.txt > dependencies.txt
