import java.lang.System
import jenkins.model.*
import hudson.security.*

def home_dir = System.getenv("JENKINS_HOME")
def properties = new ConfigSlurper().parse(new File("/usr/share/jenkins/config/authentication.properties").toURI().toURL())

if(properties.owndb.enabled) {
  println "############################ STARTING INTERNAL DATABASE SECURITY SETUP ############################"

  HudsonPrivateSecurityRealm realm = new HudsonPrivateSecurityRealm(false)
  properties.owndb.users.each() { key, value ->
    File passwordFile = new File(value.path)
    realm.createAccount(value.userId, passwordFile.text.trim())
    println ">>> Added user ${value.userId}"
  }
  def strategy = new hudson.security.FullControlOnceLoggedInAuthorizationStrategy()
  strategy.setAllowAnonymousRead(false)
  Jenkins.instance.setAuthorizationStrategy(strategy)

  Jenkins.instance.setSecurityRealm(realm)
  Jenkins.instance.save()
}
