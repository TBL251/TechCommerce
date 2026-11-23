@echo off
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-21.0.13.10002-hotspot"
set "PATH=%JAVA_HOME%\bin;%PATH%"
set "MAVEN_USER_HOME=e:\TechCommerce\.m2"
call e:\TechCommerce\mvnw.cmd -f e:\TechCommerce\pom.xml -o spring-boot:run -Dmaven.repo.local=e:\TechCommerce\.m2\repository
