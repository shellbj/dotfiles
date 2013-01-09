export ACCUREV_IGNORE_ELEMS="./install/* *.class *~ #*#"

export ORBITZ_WEB_REPOSITORY=http://wmnwaint01dp.wm.orbitz.com:16000,http://artifacts.duncllc.com

export JAVA_HOME=/usr/local/java/jdk1.6
export PATH=${JAVA_HOME}/bin:${PATH}

### Groovy
export GROOVY_HOME=/usr/local/orbitz-groovy
export PATH=${PATH}:${GROOVY_HOME}/bin

### Gradle
export GRADLE_HOME=/opt/apps/gradle-0.9
export PATH=${GRADLE_HOME}/bin:${PATH}

### Grails
export GRAILS_HOME=/opt/apps/grails-1.3.5
export PATH=${PATH}:${GRAILS_HOME}/bin

### Ant
export ANT_HOME=/usr/local/orbitz-ant2
export PATH=${PATH}:${ANT_HOME}/bin

### Orbitz Service Test
export PATH=${PATH}:/opt/orbitz-st/bin
export PATH=${PATH}:/opt/orbitz-st/jmeter/bin

export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/lib/oracle/11.1/client/lib
export ORACLE_HOME="/usr/lib/oracle/xe/app/oracle/product/10.2.0/server"
export TNS_ADMIN=${HOME}/.tnsadmin/tnsadmin

#export RUBYOPT="rrubygems"

export HADOOP_HOME=/opt/apps/hadoop-0.20.2

### Python
if [[ -s /usr/bin/virtualenvwrapper.sh ]]; then
    source /usr/bin/virtualenvwrapper.sh
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.6
    export WORKON_HOME=$HOME/.virtualenvs
    export VIRTUAL_ENV_DISABLE_PROMPT=true
fi
