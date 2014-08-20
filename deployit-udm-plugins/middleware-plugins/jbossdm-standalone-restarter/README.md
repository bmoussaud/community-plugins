# JBoss DM Standalone Restarter plugin #

This document describes the functionality provided by the jboss dm restarter plugin

See the **Deployit Reference Manual** for background information on Deployit and deployment concepts.

# Overview #


##Features##

* Trigger a stop and a start steps when deploying on a JBoss Standalone server. (restartRequired`, `restartRequiredOnNoop`)
* Define a stop and a start control task on the `jbossdm.Standalone` CI.

# Requirements #

* **Deployit requirements**
	* **Deployit**: version 3.9+
	* **JBossdm plugin **: version 3.9+

# Installation

Place the plugin JAR file into your `SERVER_HOME/plugins` directory.

# Notes #

* The commands used to start and to stop the standalone server are defined on the `jbossdm.StandaloneServer` CI.
* If the stopScript or the startScript end with ".py" so the JBOss cli is used instead of the shell based step (can be used for run the :shutdown commmand)




