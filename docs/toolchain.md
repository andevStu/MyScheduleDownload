# 개발 도구 및 패키지 구성

프로젝트는 Windows 10/11 64비트용 Java 21 데스크톱 앱입니다. 개발 도구는 프로젝트의 `.tools` 폴더에만 준비했습니다. 기존 Java 17 설치, 시스템 PATH, 레지스트리는 변경하지 않았습니다.

## 사용 버전

| 구성 요소 | 버전 | 용도와 공식 출처 |
|---|---|---|
| Eclipse Temurin JDK | 21.0.12.1+1, Windows x64 | 컴파일·실행·jpackage. [Adoptium 배포판](https://adoptium.net/temurin/releases/?arch=x64&os=windows&version=21) |
| Apache Maven | 3.9.16 | 의존성 및 빌드 관리. [Maven 다운로드](https://maven.apache.org/download.cgi) |
| Maven Wrapper | 3.3.4 | 프로젝트에 지정된 Maven 실행. [공식 Wrapper 설명](https://maven.apache.org/tools/wrapper/) |
| OpenJFX | 21.0.12 | JavaFX 화면 및 FXML. [공식 문서](https://openjfx.io/openjfx-docs/) |
| Xerial SQLite JDBC | 3.53.4.0 | 로컬 SQLite 연결. [공식 저장소](https://github.com/xerial/sqlite-jdbc) |
| SLF4J API / NOP | 2.0.17 | SQLite의 로깅 인터페이스 및 출력 없는 구현. [공식 사이트](https://www.slf4j.org/) |
| JUnit Jupiter | 5.14.4 | 서비스 및 저장소 자동 테스트. [JUnit 5](https://junit.org/junit5/) |
| WiX Toolset | 3.14.1 | Windows EXE/MSI 제작. [공식 릴리스](https://github.com/wixtoolset/wix3/releases/tag/wix3141rtm) |

JavaFX·SQLite·SLF4J·JUnit은 Maven Central에서 받습니다. JavaFX SDK와 데이터베이스 서버를 별도로 설치할 필요가 없습니다. JUnit과 Maven은 배포 앱에 포함되지 않습니다.

## 다운로드 검증

JDK는 Adoptium이 API로 게시한 SHA-256과 일치하는지 확인했습니다. Maven ZIP은 Apache의 SHA-512로 확인한 뒤 SHA-256을 Wrapper 설정에도 고정했습니다. WiX는 공식 GitHub 릴리스에서 받았으며, 별도 게시 체크섬이 없는 배포 파일의 SHA-256을 재현 가능한 다운로드용으로 기록했습니다.

```text
Temurin JDK ZIP SHA-256:
f9d6e191ab098c0d416e7d588a24420a8621cd2f4720dab2459b8b7b2d2d8b4e

Maven 3.9.16 ZIP SHA-256:
5af3b743dd8b876b5c45da33b676251e5f1687712644abb4ee519ca56e1d89ce

WiX 3.14.1 binaries ZIP SHA-256:
6ac824e1642d6f7277d0ed7ea09411a508f6116ba6fae0aa5f2c7daa2ff43d31
```

설치 파일 및 ZIP의 체크섬은 패키징할 때마다 `dist/SHA256SUMS.txt`에 생성됩니다.

## 다시 빌드하기

프로젝트 폴더에서 다음 명령을 실행합니다. `.cmd` 실행 파일이 PowerShell 실행 정책을 해당 프로세스에만 적용하므로, 시스템 실행 정책을 바꿀 필요가 없습니다.

```bat
scripts\setup.cmd -IncludeWix
mvnw.cmd test
scripts\run.cmd
scripts\package.cmd
```

`mvnw.cmd`는 `.tools/jdk-21`이 있으면 자동으로 사용합니다. `scripts\package.cmd -Type app-image`는 WiX 없이 실행 가능한 폴더와 ZIP만 만듭니다. `scripts\package.cmd -SkipBuild`는 이미 검증한 `target/app`으로 다시 패키징할 때 사용합니다. 개발 도구를 처음 받거나 새 의존성을 받는 빌드에는 인터넷 연결이 필요하며, 완성된 앱은 로컬에서 작동합니다.

## 배포 파일

| 경로 | 사용 방법 |
|---|---|
| `dist/MySchedule/MySchedule.exe` | 폴더 안에서 바로 실행합니다. 주변 `app`·`runtime` 폴더도 함께 있어야 합니다. |
| `dist/MySchedule-1.0.0-portable.zip` | 원하는 위치에 모두 압축 해제한 후 안의 실행 파일을 엽니다. |
| `dist/MySchedule-1.0.0.exe` | 현재 사용자용 Windows 설치 마법사입니다. |
| `dist/MySchedule-1.0.0.msi` | 같은 앱의 Windows Installer 패키지입니다. |

EXE와 MSI는 동일한 앱을 설치하는 대안입니다. 둘 중 하나를 사용하면 됩니다. 기본 설치 위치는 현재 사용자의 Local AppData 아래이며, 시작 메뉴와 바탕화면 바로 가기가 포함됩니다. 사용자 데이터 저장 위치와 이용 방법은 프로젝트의 사용자 안내를 참고하세요.

모든 배포 형식은 Java 실행 환경을 포함합니다. 앱 코드는 클래스 경로로 로드하며, JavaFX·SQLite JDBC·SLF4J API·SLF4J NOP 라이브러리는 `app/lib`의 명시적 모듈로 로드합니다. SQLite JDBC의 선택적 SLF4J 참조도 런처에서 명시적으로 활성화해 드라이버 탐색과 로깅 구현이 모두 해석되도록 구성했습니다. 런타임에는 화면·트레이·SQLite·FXML·한국어 로캘 등에 필요한 JDK 모듈을 넣었으며, `java.sql.rowset`과 `java.scripting`도 포함합니다. JDK 런타임의 라이선스는 `runtime/legal`, 추가 라이브러리의 라이선스와 출처는 `app/legal`에 포함됩니다. [JDK 21 패키징 안내](https://docs.oracle.com/en/java/javase/21/jpackage/packaging-overview.html)에 따라 Windows에서 제작합니다.

개발 실행과 배포 실행에는 `-Xms32m -Xmx256m -XX:+UseSerialGC`를 함께 적용합니다. Java 힙의 시작 크기는 32 MB, 최대 크기는 256 MB이며 가벼운 데스크톱 사용을 위해 Serial GC를 사용합니다. 화면·네이티브 라이브러리 메모리는 힙 밖에도 존재하므로 이 값은 전체 프로세스 메모리의 상한을 의미하지 않습니다. 프로젝트 루트의 `Start MySchedule.cmd`는 이미 만든 휴대용 앱을 실행합니다.

## 오픈 소스 고지

| 구성 요소 | 라이선스 | 원문·소스 |
|---|---|---|
| Temurin / OpenJDK | GPL v2 및 Classpath Exception, 구성 요소별 고지 | 배포 런타임의 `runtime/legal`, [Temurin 릴리스](https://github.com/adoptium/temurin21-binaries/releases/tag/jdk-21.0.12.1%2B1) |
| OpenJFX | GPL v2 및 Classpath Exception, Assembly Exception 및 구성 요소별 고지 | `licenses/javafx`, [21.0.12+3 소스](https://github.com/openjdk/jfx21u/tree/21.0.12%2B3) |
| SQLite JDBC | Apache License 2.0 및 포함된 Zentus 고지 | `licenses/sqlite`, [소스](https://github.com/xerial/sqlite-jdbc) |
| SLF4J | MIT | `licenses/slf4j`, [공식 라이선스](https://www.slf4j.org/license.html) |
| WiX 3 | Microsoft Reciprocal License | `licenses/WiX-LICENSE.txt`, [소스](https://github.com/wixtoolset/wix3) |
| Maven / Maven Wrapper | Apache License 2.0 | [Maven 라이선스](https://maven.apache.org/ref/3.9.16/maven-embedder/licenses.html), Wrapper 파일의 고지 |
| JUnit 5 | Eclipse Public License 2.0 | [소스와 라이선스](https://github.com/junit-team/junit5) |

앱의 캘린더 아이콘은 프로젝트에서 직접 작성한 SVG 도형을 `scripts/Generate-Icon.ps1`로 PNG/ICO로 변환한 것입니다.
