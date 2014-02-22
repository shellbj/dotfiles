export JAVA_HOME=/opt/java/jdk1.7
export PATH=${JAVA_HOME}/bin:${PATH}

### Groovy
export GROOVY_HOME=/usr/share/groovy
#export PATH=${PATH}:${GROOVY_HOME}/bin

### Gradle
export GRADLE_HOME=/usr/share/gradle
#export PATH=${PATH}:${GRADLE_HOME}/bin

### Grails
#export GRAILS_HOME=/usr/share/grails
#export PATH=${PATH}:${GRAILS_HOME}/bin

### Ant
export ANT_HOME=/usr/share/ant
#export PATH=${PATH}:${ANT_HOME}/bin

### Maven2
export MAVEN_HOME=/opt/maven/3.0.5
export PATH=${PATH}:${MAVEN_HOME}/bin

 # Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
