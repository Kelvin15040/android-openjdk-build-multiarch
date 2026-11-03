## JRE 25 (branch `buildjre25`)

Minecraft 26.1 and newer need Java 25. This branch builds OpenJDK 25 for Android aarch64 on a regular
GitHub-hosted runner (`.github/workflows/build.yml`):

- Source: `openjdk/jdk25u` at tag `jdk-25.0.5-ga` (pinned in `5_clonejdk.sh`).
- Patches: `patches/jre_25/android/jdk25u_android.diff`, taken from
  [FCL-Team/Android-OpenJDK-Build](https://github.com/FCL-Team/Android-OpenJDK-Build/tree/Build_JRE_25)
  (commit `7a0266e`). Two hunks were dropped because jdk-25.0.5 no longer needs them: the X11 check in
  `libraries.m4` (headless-only builds already skip X11) and the `SYS_gettid` fallback in `os_linux.cpp`
  (bionic defines it). The patch must apply cleanly; the build stops otherwise.
- Toolchain: NDK r28, Temurin 24 as boot JDK.
- Output: `JRE-25.zip`, laid out like `JRE.zip` (unzipped by Pojlib into `runtimes/JRE-25`), plus the
  usual `jre25-arm64-*.tar.xz`. Pushing a `jre25-*` tag publishes `JRE-25.zip` as a release.

# mobile-openjdk8-build-multiarch 

Based on http://openjdk.java.net/projects/mobile/android.html

## Building 

### Setup
#### Android
- Download Android NDK r10e from https://developer.android.com/ndk/downloads/older_releases.html and place it in this directory (Can't automatically download because of EULA)
- **Warning**: Do not attempt to build use newer or older NDK, it will lead to compilation errors.

#### iOS
- You should get latest Xcode (tested with Xcode 12).

### Platform and architecture specific environment variables
<table>
      <thead>
        <tr>
          <th></th>
          <th align="center" colspan="7">Environment variables</th>
        </tr>
        <tr>
          <th>Platform - Architecture</th>
          <th align="center">TARGET</th>
          <th align="center">TARGET_JDK</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Android - armv8/aarch64</td>
          <td align="center">aarch64-linux-android</td>
          <td align="center">aarch64</td>
        </tr>
        <tr>
          <td>Android - armv7/aarch32</td>
          <td align="center">arm-linux-androideabi</td>
          <td align="center">arm</td>
        </tr>
        <tr>
          <td>Android - x86/i686</td>
          <td align="center">i686-linux-android</td>
          <td align="center">x86</td>
        </tr>
        <tr>
          <td>Android - x86_64/amd64</td>
          <td align="center">x86_64-linux-android</td>
          <td align="center">x86_64</td>
        </tr>
        <tr>
          <td>iOS/iPadOS - armv8/aarch64</td>
          <td align="center">aarch64-macos-ios</td>
          <td align="center">aarch64</td>
        </tr>
      </tbody>
	</table>

### Run in this directory:
```
export BUILD_IOS=1 # only when targeting iOS, default is 0 (target Android)

export BUILD_FREETYPE_VERSION=[2.6.2/.../2.10.4] # default: 2.10.4
export JDK_DEBUG_LEVEL=[release/fastdebug/debug] # default: release
export JVM_VARIANTS=[client/server] # default: client (aarch32), server (other architectures)

# Setup NDK, run once (Android only)
./extractndk.sh
./maketoolchain.sh 

# Get CUPS, Freetype and build Freetype
./getlibs.sh
./buildlibs.sh

# Clone JDK, run once
./clonejdk.sh

# Configure JDK and build, if no configuration is changed, run makejdkwithoutconfigure.sh instead
./buildjdk.sh

# Pack the built JDK
./removejdkdebuginfo.sh
./tarjdk.sh
```

