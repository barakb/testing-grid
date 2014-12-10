#!/bin/sh
. `dirname $0`/setenv.sh

#POJO_CLASSPATH=
#HIBERNATE_HOME=


if [ "${POJO_CLASSPATH}" = "" ] ; then
  echo Please set the POJO_CLASSPATH variable prior to running the utility.
  exit
fi


for i in $1 $2 $3 $4 $5 $6 $7 $8 $9 $10
do
  if [ "$i" = "-isHibernate" ] ; then
  	if [ "${HIBERNATE_HOME}" = "" ] ; then
  		echo Please set the HIBERNATE_HOME variable prior to running the utility.
  		exit
	fi
  fi
done


# Setting JARS
JARS=${CPS}${COMMON_JARS}${CPS}${JDBC_JARS}${CPS}${SPRING_JARS}${CPS}${GS_JARS}

HIBERNATE_JARS=${HIBERNATE_JARS}${CPS}${CLASSPATH}

CLASSPATH=${HIBERNATE_HOME}${CPS}${HIBERNATE_JARS}${CPS}${HIBERNATE_HOME}/lib/commons-collections-2.1.1.jar${CPS}${JSHOMEDIR}/examples/Advanced/Data_Grid/Database-Integration/lib/dom4j-1.6.1.jar${CPS}${JSHOMEDIR}/examples/Advanced/Data_Grid/Database-Integration/lib/log4j.jar${CPS}${COMMON_JARS}${CPS}${GS_JARS}${CPS}${POJO_CLASSPATH}
echo Using CLASSPATH ${CLASSPATH}
if [ "$1" != "" ] ; then
	java -classpath ${CLASSPATH} -DsystemRoot=${CPS}$../lib/JSpaces.jar com.gigaspaces.tools.generator.GsXmlGenerator $*
else
echo ****************************************
echo Utility generates gs xml mapping files
echo ****************************************
echo   The command expects to receive the following parameters:
echo   Environment variables need to be set:
echo   POJO_CLASSPATH - The path for the POJOs class files.
echo   HIBERNATE_HOME - The path for the Hibernate configuration and jar files and the *.hbm mapping files.
echo   Parameters list:
echo   ---------------------------------------------------------------------------------------------
echo   1. -beanName the bean POJO name                         [required] if isHibernate is false
echo   Description:
echo   ============
echo   Represents the POJO fully qualified name.
echo   ---------------------------------------------------------------------------------------------
echo   2. -outputDir                                            [required]
echo   Description:
echo   ============
echo   The output directory for the generated gs xml mapping files.
echo   ---------------------------------------------------------------------------------------------
echo   3. -isHibernate                                          [optional]
echo   Description:
echo   ============
echo   Indicates whether to generate gs xml files from all *.hbm hibernate files in the classpath.
echo   The default value is false.
echo   ---------------------------------------------------------------------------------------------
echo   4. -mappingType                                      [optional]
echo   Description:
echo   ============
echo   The mapping type can be a 'space' value or a 'map' value.
echo   The default value is 'space'.
echo   ---------------------------------------------------------------------------------------------
echo   5. -isFifo                                               [optional]
echo   Description:
echo   ============
echo   Indicates whether to use fifo for all the beans.
echo   The default value is 'false'.
echo   ---------------------------------------------------------------------------------------------
echo   6. -isPersist                                         [optional]
echo   Description:
echo   ============
echo   Indicates whether to use persistent for all the beans.
echo   The default value is 'true'.
echo   ---------------------------------------------------------------------------------------------
echo   7. -isReplicate                                       [optional]
echo   Description:
echo   ============
echo   Indicates whether to use replicable for all the beans.
echo   The default value is 'true'.
echo   ---------------------------------------------------------------------------------------------
echo   8. -hibernateConfigFile                                  [optional]
echo   Description:
echo   ============
echo   The hibernate configuration file if isHibernate is true.
echo   The default value is '/hibernate.cfg.xml'.
echo   ---------------------------------------------------------------------------------------------
echo   9. -overrideFile                                         [optional]
echo   Description:
echo   ============
echo   Indicates whether to override an existing file with the same filename.
echo   The default value is 'false' which means it will create a new file using the '.new' suffix.
echo   ---------------------------------------------------------------------------------------------
echo   10. -inheritIndexes                                        [optional]
echo   Description:
echo   ============
echo   There are two values that can be chosen:
echo                a. true  - Take into account the declared indexes that are set to true, and all their superclasses.
echo                b. false - Take into account the instance's indexes, or if it's indexes are false,
echo                take into account the first superclass that contains indexes that are true.
echo   The default value is 'true'.
echo Usage Examples:
echo    ./generateGsXml.sh -beanName com.j_spaces.examples.hellospacepojo.Employee  -outputDir /gigaspaces/
echo    ./generateGsXml.sh -isHibernate true  -outputDir /gigaspaces/ -hibernateConfigFile hibernate.cfg.xml
fi
