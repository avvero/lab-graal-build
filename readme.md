#

```bash
docker-compose down --rmi all && docker-compose up
```

## build-static-executables

https://www.graalvm.org/22.3/reference-manual/native-image/guides/build-static-executables/
https://graalvm.github.io/native-build-tools/latest/gradle-plugin.html

```
export GRAALVM_HOME=`/usr/libexec/java_home -v 17.0.5`
PATH=$PATH:$GRAALVM_HOME/bin

jar cmvf META-INF/MANIFEST.MF <new-jar-filename>.jar  <files to include>

native-image -jar ./build/libs/demo-0.0.1-SNAPSHOT-plain.jar
```