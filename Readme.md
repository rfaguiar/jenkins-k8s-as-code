

Extract plugin list:  
http://<JENKINS_URL>/script  

Jenkins.instance.pluginManager.plugins.each{
  plugin ->
    println ("${plugin.getShortName()}:${plugin.getVersion()}")
}