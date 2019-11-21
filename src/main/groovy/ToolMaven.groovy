import hudson.tasks.Maven
import hudson.tasks.Maven.MavenInstallation
import hudson.tools.InstallSourceProperty
import hudson.tools.ToolProperty
import hudson.tools.ToolPropertyDescriptor
import hudson.tools.ZipExtractionInstaller
import hudson.util.DescribableList
import jenkins.model.Jenkins

println "############################ STARTING MAVEN CONFIG ############################"
def home_dir = System.getenv("JENKINS_HOME")
def properties = new ConfigSlurper().parse(new File("$home_dir/config/tools.properties").toURI().toURL())

def extensions = Jenkins.getInstanceOrNull().getExtensionList(Maven.DescriptorImpl.class).get(0)

List<MavenInstallation> installations = []

properties.maven.each { mavenTool ->
    println(">>> Setting up tool: ${mavenTool.value.name} ")
    def describableList = new DescribableList<ToolProperty<?>, ToolPropertyDescriptor>()
    mavenTool.value.get('installers').each { installerItem ->
        def installer = null
        if(installerItem.value.type == 'ZipExtractionInstaller') {
            installer = new ZipExtractionInstaller(installerItem.value.label as String,
                    installerItem.value.url as String,
                    installerItem.value.subdir as String)
        } else if (installerItem.value.type == 'MavenInstaller') {
            installer = new Maven.MavenInstaller(installerItem.value.version)
        }
        describableList.add(new InstallSourceProperty([installer]))
    }

    installations.add(new MavenInstallation(mavenTool.value.name as String,
            "", describableList))
}

extensions.setInstallations(installations.toArray(new MavenInstallation[installations.size()]))
extensions.save()
