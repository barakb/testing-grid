@echo off
cls
@call %~dp0\setenv.bat
if "%1" EQU "" goto usage

rem set HIBERNATE_HOME
rem set POJO_CLASSPATH

if "%POJO_CLASSPATH%" == "" (
  @echo Please set the POJO_CLASSPATH variable prior to running the utility.
  goto end
)


:LOOP
if "%1"==""  goto  DONE
if "%1"=="-isHibernate"  goto  HIBERNATE
shift
goto loop

:hibernate
if "%HIBERNATE_HOME%" == "" (
  @echo Please set the HIBERNATE_HOME variable prior to running the utility.
  goto end
)
set HIBERNATE_JARS=%HIBERNATE_JARS%;%CLASSPATH%
:done

rem Setting JARS

set JARS=%COMMON_JARS%;%JDBC_JARS%;%SPRING_JARS%;%GS_JARS%
set CLASSPATH=%HIBERNATE_JARS%;%HIBERNATE_HOME%/lib/commons-collections-2.1.1.jar;%JSHOMEDIR%/examples/Advanced/Data_Grid/Database-Integration/lib/dom4j-1.6.1.jar;%JSHOMEDIR%/examples/Advanced/Data_Grid/Database-Integration/lib/log4j.jar;%COMMON_JARS%;%GS_JARS%;%POJO_CLASSPATH%
echo Using CLASSPATH=%CLASSPATH%
java -classpath %CLASSPATH% -DsystemRoot=../lib/JSpaces.jar com.gigaspaces.tools.generator.GsXmlGenerator %*
goto end



:usage
@echo ****************************************
@echo Utility generates gs xml mapping files
@echo ****************************************
@echo   The command expects to receive the following parameters:
@echo   Environment variables need to be set:
@echo   POJO_CLASSPATH - The path for the POJOs class files.
@echo   HIBERNATE_HOME - The path for the Hibernate configuration and jar files and the *.hbm mapping files.
@echo   Parameters list:
@echo   --------------------------------------------------------------------------------------------
@echo   1. -beanName the bean(POJO) name                         [required] if isHibernate is false
@echo   Description:
@echo   ============
@echo   Represents the POJO fully qualified name.
@echo   --------------------------------------------------------------------------------------------
@echo   2. -outputDir                                            [required]
@echo   Description:
@echo   ============
@echo   The output directory for the generated gs xml mapping files.
@echo   --------------------------------------------------------------------------------------------
@echo   3. -isHibernate                                          [optional]
@echo   Description:
@echo   ============
@echo   Indicates whether to generate gs xml files from all *.hbm hibernate files in the classpath.
@echo   The default value is false.
@echo   --------------------------------------------------------------------------------------------
@echo   4. -mappingType                                      [optional]
@echo   Description:
@echo   ============
@echo   The mapping type can be a 'space' value or a 'map' value.
@echo   The default value is 'space'.
@echo   --------------------------------------------------------------------------------------------
@echo   5. -isFifo                                               [optional]
@echo   Description:
@echo   ============
@echo   Indicates whether to use fifo for all the beans.
@echo   The default value is 'false'.
@echo   --------------------------------------------------------------------------------------------
@echo   6. -isPersist                                         [optional]
@echo   Description:
@echo   ============
@echo   Indicates whether to use persistent for all the beans.
@echo   The default value is 'true'.
@echo   --------------------------------------------------------------------------------------------
@echo   7. -isReplicate                                       [optional]
@echo   Description:
@echo   ============
@echo   Indicates whether to use replicable for all the beans.
@echo   The default value is 'true'.
@echo   --------------------------------------------------------------------------------------------
@echo   8. -hibernateConfigFile                                  [optional]
@echo   Description:
@echo   ============
@echo   The hibernate configuration file if isHibernate is true.
@echo   The default value is '/hibernate.cfg.xml'.
@echo   --------------------------------------------------------------------------------------------
@echo   9. -overrideFile                                         [optional]
@echo   Description:
@echo   ============
@echo   Indicates whether to override an existing file with the same filename.
@echo   The default value is 'false' which means it will create a new file using the '.new' suffix.
@echo   --------------------------------------------------------------------------------------------
@echo   10. -inheritIndexes                                        [optional]
@echo   Description:
@echo   ============
@echo   There are two values that can be chosen:
echo                a. true  - Take into account the declared indexes that are set to true, and all their superclasses.
echo                b. false - Take into account the instance's indexes, or if it's indexes are false,
echo                take into account the first superclass that contains indexes that are true.
echo   The default value is 'true'.
@echo Example:
@echo    generateGsXml -beanName com.j_spaces.examples.hellospacepojo.Employee  -outputDir D:\dev\gigaspaces\
@echo    generateGsXml -isHibernate true  -outputDir D:\dev\gigaspaces\ -hibernateConfigFile	hibernate.cfg.xml
pause
:end

