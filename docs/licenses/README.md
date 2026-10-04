# Bundled third-party notices

These files accompany unmodified third-party libraries used by MySchedule.

- `javafx`: OpenJFX 21.0.12. License, Classpath Exception, assembly exception, additional license information, and the JPEG/Mesa notices used by JavaFX Graphics. Files are from the official [21.0.12+3 source tag](https://github.com/openjdk/jfx21u/tree/21.0.12%2B3). Only base, graphics, controls, and FXML modules are used; media and WebKit are not shipped.
- `sqlite`: License files extracted without alteration from the `sqlite-jdbc-3.53.4.0.jar` published by [Xerial](https://github.com/xerial/sqlite-jdbc).
- `slf4j`: MIT license extracted without alteration from `slf4j-api-2.0.17.jar`; it also applies to the matching NOP implementation. [SLF4J license](https://www.slf4j.org/license.html).
- `WiX-LICENSE.txt`: License accompanying the official WiX Toolset 3.14.1 binaries used to produce the installer.

The bundled Temurin 21.0.12.1 runtime retains its own complete module-specific notices in `runtime/legal` beside the application's `app` directory. Original releases and sources are linked from `toolchain.md`.

Maven, Maven Wrapper, and JUnit are development dependencies, not runtime libraries in the application. The wrapper retains its Apache license header. Development tool distributions retain their own license files.
