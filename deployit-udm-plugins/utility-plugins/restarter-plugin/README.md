# Restarter plugin #

# Overview #

The Restarted plugin allows to generate stop and start steps from another containers when deploying to a container

# Requirements #

* **Deployit requirements**
	* **Deployit**: version 3.9

# Installation #

Place the plugin JAR file into your `SERVER_HOME/plugins` directory. 

A new category is added to the udm.Enviroment CI: 'SLA'. It offers a place to define the range in which all the deployment should not be executed and which action should be executed in case of failure (Continue, Pause the task, Fail the task or Wait for ).
The format used to defined the date and the time are configurable using the datePattern and timePattern hidden properties.
