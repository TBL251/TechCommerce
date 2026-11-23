@REM Licensed to the Apache Software Foundation (ASF) under one
@REM or more contributor license agreements.  See the NOTICE file
@REM distributed with this work for additional information
@REM regarding copyright ownership.  The ASF licenses this file
@REM to you under the Apache License, Version 2.0 (the
@REM "License"); you may not use this file except in compliance
@REM with the License.  You may obtain a copy of the License at
@REM
@REM   http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing,
@REM software distributed under the License is distributed on an
@REM "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
@REM KIND, either express or implied.  See the License for the
@REM specific language governing permissions and limitations
@REM under the License.
@echo off
setlocal

set WRAPPER_DIR=%~dp0
set MAVEN_WRAPPER_PROPS=%WRAPPER_DIR%.mvn\wrapper\maven-wrapper.properties

if "%MAVEN_USER_HOME%"=="" (
  set "M2_HOME_BASE=%USERPROFILE%\.m2"
) else (
  set "M2_HOME_BASE=%MAVEN_USER_HOME%"
)

set "MAVEN_DIST_DIR=%M2_HOME_BASE%\wrapper\dists\apache-maven-3.9.9"
set "MAVEN_CMD=%MAVEN_DIST_DIR%\apache-maven-3.9.9\bin\mvn.cmd"

if not exist "%MAVEN_CMD%" (
  powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$ErrorActionPreference = 'Stop'; " ^
    "$distUrl = 'https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.9/apache-maven-3.9.9-bin.zip'; " ^
    "$destDir = '%MAVEN_DIST_DIR%'; " ^
    "New-Item -ItemType Directory -Force -Path $destDir | Out-Null; " ^
    "$zipPath = Join-Path $destDir 'maven.zip'; " ^
    "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; " ^
    "Invoke-WebRequest -Uri $distUrl -OutFile $zipPath; " ^
    "Expand-Archive -Path $zipPath -DestinationPath $destDir -Force; " ^
    "Remove-Item $zipPath -Force"
  if errorlevel 1 exit /b 1
)

call "%MAVEN_CMD%" %*
exit /b %ERRORLEVEL%
