import hudson.model.JDK
import hudson.tools.InstallSourceProperty
import hudson.tools.ZipExtractionInstaller

def descriptor = new JDK.DescriptorImpl();

def List<JDK> installations = []

def home_dir = System.getenv("JENKINS_HOME")
def properties = new ConfigSlurper().parse(new File("$home_dir/config/tools.properties").toURI().toURL())

println "############################ STARTING JDKs CONFIG ############################"

properties.jdk.each { javaTool ->
    if(javaTool.value.enabled) {
        println(">>> Setting up tool: ${javaTool}")

        // def installer = new ZipExtractionInstaller(javaTool.value.label as String, javaTool.value.url as String, javaTool.value.subdir as String);
        def installer = new ZipExtractionInstaller( javaTool.value.get('label', ""),
                                                    javaTool.value.get('url', ""),
                                                    javaTool.value.get('subdir', "") )
        def jdk = new JDK(javaTool.value.name as String, null, [new InstallSourceProperty([installer])])
        installations.add(jdk)
    }
}
descriptor.setInstallations(installations.toArray(new JDK[installations.size()]))
descriptor.save()
