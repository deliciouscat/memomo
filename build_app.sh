#!/bin/bash

# 빌드 디렉토리 설정
BUILD_DIR=".build/release"
APP_NAME="Memomo"
APP_BUNDLE="${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

# 앱 번들 디렉토리 생성
echo "앱 번들 생성 중..."
rm -rf "${APP_BUNDLE}"
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

# 실행 파일 복사
if [ ! -f "${BUILD_DIR}/${APP_NAME}" ]; then
    echo "오류: ${BUILD_DIR}/${APP_NAME} 파일을 찾을 수 없습니다."
    echo "먼저 'swift build -c release'를 실행하세요."
    exit 1
fi

echo "실행 파일 복사 중..."
cp "${BUILD_DIR}/${APP_NAME}" "${MACOS_DIR}/${APP_NAME}"

# Swift Package Manager 리소스 번들 복사
RESOURCE_BUNDLE="${BUILD_DIR}/${APP_NAME}_${APP_NAME}.bundle"
if [ -d "${RESOURCE_BUNDLE}" ]; then
    echo "리소스 번들 복사 중..."
    cp -r "${RESOURCE_BUNDLE}" "${RESOURCES_DIR}/"
else
    echo "경고: 리소스 번들을 찾을 수 없습니다: ${RESOURCE_BUNDLE}"
fi

# 추가 리소스 복사 (필요한 경우)
if [ -d "Memomo/Resources" ]; then
    echo "추가 리소스 복사 중..."
    cp -r "Memomo/Resources"/* "${RESOURCES_DIR}/" 2>/dev/null || true
fi

# Info.plist 생성
echo "Info.plist 생성 중..."
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
    <key>CFBundleDisplayName</key>
    <string>${APP_NAME}</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.productivity</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>NSSupportsAutomaticTermination</key>
    <true/>
    <key>NSSupportsSuddenTermination</key>
    <true/>
    <key>NSAppleEventsUsageDescription</key>
    <string>Memomo는 작업 시간을 추적하기 위해 실행 중인 앱 정보에 접근합니다.</string>
    <key>NSSystemAdministrationUsageDescription</key>
    <string>Memomo는 생산성 통계를 수집하기 위해 시스템 정보에 접근합니다.</string>
</dict>
</plist>
EOF

# PkgInfo 생성 (선택사항이지만 권장)
echo -n "APPL????" > "${CONTENTS_DIR}/PkgInfo"

# 실행 권한 부여
chmod +x "${MACOS_DIR}/${APP_NAME}"

# 디버그: 앱 번들 구조 검증
echo ""
echo "🔍 앱 번들 검증 중..."
if [ -f "${MACOS_DIR}/${APP_NAME}" ]; then
    echo "✓ 실행 파일 존재"
    file "${MACOS_DIR}/${APP_NAME}"
fi
if [ -f "${CONTENTS_DIR}/Info.plist" ]; then
    echo "✓ Info.plist 존재"
fi
if [ -d "${RESOURCES_DIR}/Memomo_Memomo.bundle" ]; then
    echo "✓ 리소스 번들 존재"
fi

echo ""
echo "✅ 완료! ${APP_BUNDLE} 생성됨"
echo "📍 위치: $(pwd)/${APP_BUNDLE}"
echo ""
echo "실행하려면:"
echo "  open ${APP_BUNDLE}"
echo ""
echo "📝 참고: Xcode 실행과 동일한 동작을 위해서는"
echo "   System Settings > Privacy & Security에서 필요한 권한을 허용해야 할 수 있습니다."
echo ""
