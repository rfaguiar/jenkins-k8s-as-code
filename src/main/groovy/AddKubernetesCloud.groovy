import jenkins.model.Jenkins
import org.csanchez.jenkins.plugins.kubernetes.ContainerTemplate
import org.csanchez.jenkins.plugins.kubernetes.KubernetesCloud
import org.csanchez.jenkins.plugins.kubernetes.PodTemplate
import org.csanchez.jenkins.plugins.kubernetes.volumes.HostPathVolume
import org.csanchez.jenkins.plugins.kubernetes.volumes.PodVolume

println "############################ KUBERNETES CLOUDs SETUP ############################"

if( ! System.getenv().containsKey('KUBERNETES_SERVER_URL') ) {
    println(">>> ENV VAR 'KUBERNETES_SERVER_URL' not found")
    println(">>> Please set them before start Jenkins")
    return
}

def jenkins = Jenkins.getInstanceOrNull()
def cloudList = jenkins.clouds

def home_dir = System.getenv("JENKINS_HOME")
def properties = new ConfigSlurper().parse(new File("/usr/share/jenkins/config//clouds.properties").toURI().toURL())

// KUBERNETES CLOUD (URLs)
//     > POD TEMPLATE [List] (Namespace, Label)
//         > CONTAINER TEMPLATE [List] (Docker Image, Docker args)

properties.kubernetes.each { cloudKubernetes ->
    println ">>> Kubernetes Cloud Setting up: " + cloudKubernetes.value.get('name')

    List<PodTemplate> podTemplateList = new ArrayList<PodTemplate>()
    cloudKubernetes.value.get('pods').each { podTemplate ->
        println ">>>>>> POD Template setup: " + podTemplate.value.get('name')
        def newPodTemplate = createBasicPODTemplate(podTemplate)

        List<ContainerTemplate> containerTemplateList = new ArrayList<ContainerTemplate>()
        podTemplate.value.get('containers').each { containerTemplate ->
            println ">>>>>>>>> Container Template setup: " + containerTemplate.value.get('name')
            containerTemplateList.add( createBasicContainerTemplate(containerTemplate) )
        }

        newPodTemplate.setContainers(containerTemplateList)
        podTemplateList.add(newPodTemplate)
    }
    def kubernetesCloud = createKubernetesCloud(cloudKubernetes, podTemplateList)
    cloudList.add(kubernetesCloud)
}
jenkins.save()
println("Clouds Adicionadas: " + Jenkins.getInstanceOrNull().clouds.size())

// METODOS AUXILIARES
def createKubernetesCloud(cloudKubernetes, podTemplateList) {
    def serverUrl = System.getenv("KUBERNETES_SERVER_URL")
    def jenkinsUrl = System.getenv("JENKINS_SERVER_URL")
    def kubernetesCloud = new KubernetesCloud(
            cloudKubernetes.value.get('name'),
            podTemplateList,
            serverUrl,
            cloudKubernetes.value.get('namespace'),
            jenkinsUrl,
            cloudKubernetes.value.get('containerCapStr'),
            cloudKubernetes.value.get('connectTimeout'),
            cloudKubernetes.value.get('readTimeout'),
            cloudKubernetes.value.get('retentionTimeout') )
    return kubernetesCloud
}

def createBasicPODTemplate(podTemplate) {
    PodTemplate defaultPod = new PodTemplate()
    defaultPod.setName(podTemplate.value.get('name'))
    defaultPod.setNamespace(podTemplate.value.get('namespace'))
    defaultPod.setLabel(podTemplate.value.get('label'))

    List<PodVolume> listPodVolume = new ArrayList<>()
    podTemplate.value.get('volumes').each { volumeTemplate ->
        listPodVolume.add(createVolume(volumeTemplate))
    }
    defaultPod.setVolumes(listPodVolume)
    return defaultPod
}

def createBasicContainerTemplate(containerTemplate) {
    ContainerTemplate basicContainerTemplate = new ContainerTemplate(
            containerTemplate.value.get('name', ''),
            containerTemplate.value.get('image', ''),
            containerTemplate.value.get('command', ''),
            containerTemplate.value.get('args', ''))
    basicContainerTemplate.setWorkingDir(containerTemplate.value.get('workDirectory', ''))
    basicContainerTemplate.setTtyEnabled(containerTemplate.value.get('ttyEnabled', true))
    return basicContainerTemplate;
}

def createVolume(volumeTemplate) {
    String hostPath = volumeTemplate.value.get('hostPath')
    String mountPath = volumeTemplate.value.get('mountPath')
    if (!mountPath.isEmpty() && !mountPath.isEmpty()) {
        return new HostPathVolume(hostPath, mountPath);
    }
    return null;
}
