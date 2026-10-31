param(
    [string]$StorePassword = "",
    [string]$Version = "1.6.4",
    [string]$KeystorePath = "",
    [string]$KeyAlias = "mangmi"
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
if (-not $StorePassword) {
    $StorePassword = $env:LENS_KEYSTORE_PASSWORD
}
if (-not $StorePassword) {
    throw "请通过 -StorePassword 或 LENS_KEYSTORE_PASSWORD 提供签名密码。"
}
$sdk = if ($env:ANDROID_SDK_ROOT) {
    $env:ANDROID_SDK_ROOT
} elseif ($env:ANDROID_HOME) {
    $env:ANDROID_HOME
} else {
    Join-Path $root ".android-sdk"
}
$localGradle = Join-Path $root "gradle-8.11.1\bin\gradle.bat"
$gradle = if (Test-Path -LiteralPath $localGradle) {
    $localGradle
} else {
    Join-Path $root "gradlew.bat"
}
$zipalign = Join-Path $sdk "build-tools\35.0.0\zipalign.exe"
$apksigner = Join-Path $sdk "build-tools\35.0.0\apksigner.bat"
$keystore = if ($KeystorePath) {
    $KeystorePath
} else {
    Join-Path $root "signing\mangmi-release.jks"
}
$unsigned = Join-Path $root "app\build\outputs\apk\release\app-release-unsigned.apk"
$aligned = Join-Path $root "dist\app-release-aligned.apk"
$final = Join-Path $root "dist\LensController-$Version.apk"

$env:ANDROID_HOME = $sdk
$env:ANDROID_SDK_ROOT = $sdk
$env:ANDROID_USER_HOME = Join-Path $root ".android-user-home"
if (-not $env:JAVA_HOME) {
    $localJdk = "C:\Program Files\Microsoft\jdk-21.0.7.6-hotspot"
    if (Test-Path -LiteralPath $localJdk) {
        $env:JAVA_HOME = $localJdk
    }
}
if (-not (Test-Path -LiteralPath $keystore)) {
    throw "发布签名文件不存在：$keystore"
}

& $gradle --gradle-user-home (Join-Path $root ".gradle-home") --no-daemon `
    testReleaseUnitTest assembleRelease
if ($LASTEXITCODE -ne 0) {
    throw "Gradle 构建失败。"
}

New-Item -ItemType Directory -Path (Split-Path $final) -Force | Out-Null
& $zipalign -p -f 4 $unsigned $aligned
if ($LASTEXITCODE -ne 0) {
    throw "APK 对齐失败。"
}

& $apksigner sign `
    --ks $keystore `
    --ks-key-alias $KeyAlias `
    --ks-pass "pass:$StorePassword" `
    --key-pass "pass:$StorePassword" `
    --out $final `
    $aligned
if ($LASTEXITCODE -ne 0) {
    throw "APK 签名失败。"
}

& $apksigner verify --verbose --print-certs $final
Remove-Item -LiteralPath $aligned -Force
Write-Host "已生成：$final" -ForegroundColor Green
