#!/bin/bash
#
# Copyright 2010 Google Inc.

# For local modifications, please set these variables here.
OVERRIDE_JAVABIN=
OVERRIDE_DEPLOYJAR=
OVERRIDE_RUNDIR=
OVERRIDE_SYSCONFDIR=

JAVABIN=${OVERRIDE_JAVABIN:-/usr/bin/java}
DEPLOYJAR=${OVERRIDE_DEPLOYJAR:-$(pwd)/lib/sdc-agent.jar}

RUNDIR=${OVERRIDE_RUNDIR:-$(pwd)}
SYSCONFDIR=${OVERRIDE_SYSCONFDIR:-$(pwd)/config}

CONFIGFILE=${SYSCONFDIR}/localConfig.xml
RULESFILE=${SYSCONFDIR}/resourceRules.xml
LOG4JPROPERTIESFILE=${SYSCONFDIR}/log4j.properties
PASSWORDFILE=${SYSCONFDIR}/mypassword

# Generated by this script:
PIDFILE=${RUNDIR}/agent.pid


JVM_ARGS="-Djava.net.preferIPv4Stack=true"
DEBUG=""

on_sighup() {
  echo "Caught SIGHUP; ignored. $(date)" >&2
}

trap on_sighup SIGHUP

# Create flags for local config file.
OPTS=$(getopt -o dnf:r:j: --long debug,localConfigFile::,rulesFile::,jvm_args:: -n 'runagent' -- "$@")
if [ $? != 0 ]; then
  echo -e "\nUsage:
    -d|--debug) Place into debug mode
    -f|--localConfigFile) Local configuration file
    -r|--rulesFile) Resource rules file.
    -j|--jvm-args) Override default jvmargs with these.
  " >&2
  exit 1
fi

# Parse command line
eval set -- "${OPTS}"
while true; do
  case "$1" in
    -d|--debug) DEBUG="--debug"; shift 1 ;;
    -f|--localConfigFile) CONFIGFILE=$2; shift 2 ;;
    -r|--rulesFile) RULESFILE=$2; shift 2 ;;
    -j|--jvm-args) JVM_ARGS=$2; shift 2 ;;
    -l|--log4jPropertiesFile) LOG4JPROPERTIESFILE=$2; shift 2 ;;
    --) shift ; break ;;
    *) echo "Error!" ; exit 1 ;;
  esac
done

# Make sure we are the only one who can read any generated files.
umask 0077


echo -e "\n\n\n\n"
echo -e "*******************************************************************"
echo -e "Date: $(date)"
echo -e "Config directory: ${SYSCONFIGDIR}"
echo -e "Runtime directory: ${RUNDIR}"
echo -e "PID file: ${PIDFILE}"

# Other flags passed from the command line when invoking this script.
ADDITIONAL_FLAGS="$@"

echo -e "args = ${ADDITIONAL_FLAGS}"
echo -e "Password file = ${PASSWORDFILE}"

# If the password file is specified, use a flag to specify it.
if [ -r "${PASSWORDFILE}" ]; then
  PASSWORD_FLAG="-passwordFile \"${PASSWORDFILE}\""
fi

CMD="${JAVABIN} ${JVM_ARGS} -jar ${DEPLOYJAR} ${DEBUG} \
-localConfigFile \"${CONFIGFILE}\" \
-rulesFile \"${RULESFILE}\" \
-log4jPropertiesFile \"${LOG4JPROPERTIESFILE}\" \
${PASSWORD_FLAG} \
${ADDITIONAL_FLAGS} \
"

echo -e "Run: ${CMD}"
${CMD}
export AGENT_PID="$!"

# Log the PID of the launched process
if [ -e "${RUNDIR}" ]; then
  echo ${AGENT_PID} > ${PIDFILE}
else
  echo ${AGENT_PID}
fi


