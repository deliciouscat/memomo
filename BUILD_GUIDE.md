# Memomo 앱 빌드 및 배포 가이드

이 문서는 Memomo 프로젝트를 빌드하고 `.app` 파일을 생성하는 방법을 설명합니다.

## 사전 준비

- macOS 13 이상
- Xcode 최신 버전
- Swift 5.9 이상

## 빌드 방법

### 방법 1: Xcode를 사용한 빌드 (권장)

1. **프로젝트 열기**
   ```bash
   open Package.swift
   ```
   또는 Xcode에서 `File > Open`으로 `Package.swift` 파일을 엽니다.

2. **빌드 설정 확인**
   - Xcode 상단에서 스키마를 `Memomo`로 선택
   - 빌드 타겟을 `My Mac`으로 선택

3. **빌드 실행**
   - `Product > Build` (단축키: `Cmd + B`)
   - 또는 `Product > Archive` (배포용)

4. **빌드된 앱 위치**
   - 빌드가 완료되면 Xcode의 Products 폴더에서 `Memomo` 실행 파일을 확인할 수 있습니다.
   - 실제 `.app` 번들을 생성하려면 아래 "앱 번들 생성" 섹션을 참고하세요.

### 방법 2: 커맨드라인 빌드

1. **프로젝트 디렉토리로 이동**
   ```bash
   cd /Users/deliciouscat/projects/Memomo
   ```

2. **빌드 실행**
   ```bash
   swift build -c release
   ```
   
   또는 Xcode 빌드 시스템 사용:
   ```bash
   xcodebuild -scheme Memomo -configuration Release build
   ```

3. **빌드 결과 확인**
   - Swift Package Manager: `.build/release/Memomo` 실행 파일 생성
   - Xcode 빌드: `DerivedData` 폴더에 빌드 결과 생성

## 앱 번들(.app) 생성

Swift Package Manager로 빌드된 실행 파일을 macOS 앱 번들로 변환하는 방법입니다.

### 스크립트를 사용한 자동 생성

프로젝트 루트에 다음 스크립트를 저장하고 실행합니다:

```bash
#!/bin/bash

# 빌드 디렉토리 설정
BUILD_DIR=".build/release"
APP_NAME="Memomo"
APP_BUNDLE="${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

# Release 빌드
echo "빌드 중..."
swift build -c release

# 앱 번들 디렉토리 생성
echo "앱 번들 생성 중..."
rm -rf "${APP_BUNDLE}"
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

# 실행 파일 복사
cp "${BUILD_DIR}/${APP_NAME}" "${MACOS_DIR}/${APP_NAME}"

# 리소스 복사 (Assets, 아이콘 등)
cp -r "Memomo/Resources"/* "${RESOURCES_DIR}/" 2>/dev/null || true

# Info.plist 생성
cat > "${CONTENTS_DIR}/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>com.memomo.app</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

# 실행 권한 부여
chmod +x "${MACOS_DIR}/${APP_NAME}"

echo "완료! ${APP_BUNDLE} 생성됨"
```

스크립트를 실행 가능하게 만들고 실행:
```bash
chmod +x build_app.sh
./build_app.sh
```

### 수동 생성

1. **앱 번들 디렉토리 구조 생성**
   ```bash
   mkdir -p Memomo.app/Contents/MacOS
   mkdir -p Memomo.app/Contents/Resources
   ```

2. **실행 파일 복사**
   ```bash
   cp .build/release/Memomo Memomo.app/Contents/MacOS/Memomo
   chmod +x Memomo.app/Contents/MacOS/Memomo
   ```

3. **리소스 복사**
   ```bash
   cp -r Memomo/Resources/* Memomo.app/Contents/Resources/
   ```

4. **Info.plist 생성**
   `Memomo.app/Contents/Info.plist` 파일을 생성하고 다음 내용을 추가:
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
   <plist version="1.0">
   <dict>
       <key>CFBundleExecutable</key>
       <string>Memomo</string>
       <key>CFBundleIdentifier</key>
       <string>com.memomo.app</string>
       <key>CFBundleName</key>
       <string>Memomo</string>
       <key>CFBundlePackageType</key>
       <string>APPL</string>
       <key>CFBundleShortVersionString</key>
       <string>1.0</string>
       <key>CFBundleVersion</key>
       <string>1</string>
       <key>LSMinimumSystemVersion</key>
       <string>13.0</string>
       <key>NSHighResolutionCapable</key>
       <true/>
   </dict>
   </plist>
   ```

## 앱 실행 및 테스트

생성된 앱 번들을 실행:
```bash
open Memomo.app
```

또는 Finder에서 직접 더블클릭하여 실행할 수 있습니다.

## 배포 준비

### 코드 서명 (선택사항)

앱을 배포하려면 코드 서명이 필요할 수 있습니다:

```bash
codesign --deep --force --verify --verbose --sign "Developer ID Application: Your Name" Memomo.app
```

### 앱 번들 검증

```bash
codesign --verify --verbose Memomo.app
spctl --assess --verbose Memomo.app
```

### DMG 생성 (선택사항)

배포용 DMG 파일 생성:

```bash
hdiutil create -volname "Memomo" -srcfolder Memomo.app -ov -format UDZO Memomo.dmg
```

## 문제 해결

### 빌드 오류 발생 시

1. **의존성 업데이트**
   ```bash
   swift package update
   ```

2. **클린 빌드**
   ```bash
   swift package clean
   swift build -c release
   ```

3. **Xcode DerivedData 삭제**
   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```

### 앱이 실행되지 않는 경우

1. **실행 권한 확인**
   ```bash
   ls -l Memomo.app/Contents/MacOS/Memomo
   chmod +x Memomo.app/Contents/MacOS/Memomo
   ```

2. **콘솔 로그 확인**
   ```bash
   log stream --predicate 'process == "Memomo"' --level debug
   ```

3. **Info.plist 확인**
   - `CFBundleExecutable`이 실행 파일 이름과 일치하는지 확인
   - 필수 키가 모두 포함되어 있는지 확인

## 참고사항

- 빌드된 `.app` 파일은 `.gitignore`에 의해 Git에서 제외됩니다.
- Release 빌드는 최적화되어 있으며 디버깅 정보가 포함되지 않습니다.
- 앱 번들 구조는 macOS 앱의 표준 구조를 따라야 합니다.
