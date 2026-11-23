#!/bin/sh
set -e

WRAPPER_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
M2_HOME_BASE="${MAVEN_USER_HOME:-$HOME/.m2}"
MAVEN_DIST_DIR="$M2_HOME_BASE/wrapper/dists/apache-maven-3.9.9"
MAVEN_BIN="$MAVEN_DIST_DIR/apache-maven-3.9.9/bin/mvn"

if [ ! -x "$MAVEN_BIN" ]; then
  mkdir -p "$MAVEN_DIST_DIR"
  ZIP_PATH="$MAVEN_DIST_DIR/maven.zip"
  curl -fsSL "https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/3.9.9/apache-maven-3.9.9-bin.zip" -o "$ZIP_PATH"
  unzip -q -o "$ZIP_PATH" -d "$MAVEN_DIST_DIR"
  rm -f "$ZIP_PATH"
  chmod +x "$MAVEN_BIN"
fi

exec "$MAVEN_BIN" "$@"
