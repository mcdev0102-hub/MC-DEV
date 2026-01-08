@echo off
::  PaperMC Installer v1.0  –  Desteklenen Paper Sürümleri
::  ----------------------------------------------------------
setlocal EnableExtensions EnableDelayedExpansion
chcp 65001 >nul 2>&1
title PaperMC Installer v1.0
color 0A
mode con: cols=90 lines=45

::  ----------------  SABİTLER  ----------------
set "VERSION=1.0"
set "DESKTOP=%USERPROFILE%\Desktop"
set "LOG=%DESKTOP%\Paper_Installer_%DATE:~-4,4%%DATE:~-10,2%%DATE:~-7,2%.log"
set "TEMP_DIR=%TEMP%\PaperInstaller_%RANDOM%"

::  ----------------  LOG BAŞLAT  ----------------
>"%LOG%" echo [%DATE% %TIME%] =====  PaperMC Installer v%VERSION%  =====
>>"%LOG%" echo [%DATE% %TIME%] Running as: %USERDOMAIN%\%USERNAME%

::  ----------------  YÖNETİCİ KONTROL  ----------------
fltmc >nul 2>&1 || (
    cls & echo. & echo  [HATA] Bu program yönetici haklari gerekli!
    echo  Sağ tık → "Yönetici olarak çalıştır" seçin.
    >>"%LOG%" echo [%DATE% %TIME%] HATA: Yönetici değil
    timeout /t 7 >nul & exit /b 1
)
>>"%LOG%" echo [%DATE% %TIME%] Yönetici ONAY

::  ----------------  İNTERNET KONTROL  ----------------
:netCheck
ping -n 1 -w 3000 1.1.1.1 >nul 2>&1 && goto :netOK
cls & echo. & echo  [HATA] İnternet yok! & echo  Tekrar denemek için bir tuşa basın...
>>"%LOG%" echo [%DATE% %TIME%] HATA: İnternet yok
pause >nul & goto :netCheck
:netOK
>>"%LOG%" echo [%DATE% %TIME%] İnternet OK

::  ----------------  TEMP KLASÖRÜ  ----------------
mkdir "%TEMP_DIR%" 2>nul
cd /d "%TEMP_DIR%" || (
    echo  [HATA] Temp klasör oluşturulamadı & pause & exit /b 1
)

::  ======================================================
::  ANA MENÜ - DESTEKLENEN PAPER SÜRÜMLERİ
::  ======================================================
:mainMenu
cls
echo.
echo       ==========================================
echo          PaperMC Installer v%VERSION%
echo       ==========================================
echo        Desteklenen Paper Sürümleri (Java 16-21)
echo.
echo   [1]  1.21.4 (latest)        ^| Java 21
echo   [2]  1.21.3                 ^| Java 21
echo   [3]  1.21.2                 ^| Java 21
echo   [4]  1.21.1                 ^| Java 21
echo.
echo   [5]  1.20.6                 ^| Java 17-21
echo   [6]  1.20.5                 ^| Java 17-21
echo   [7]  1.20.4                 ^| Java 17-21
echo   [8]  1.20.3                 ^| Java 17-21
echo   [9]  1.20.2                 ^| Java 17-21
echo   [10] 1.20.1                 ^| Java 17-21
echo.
echo   [11] 1.19.4                 ^| Java 17-21
echo   [12] 1.19.3                 ^| Java 17-21
echo   [13] 1.19.2                 ^| Java 17-21
echo.
echo   [14] 1.18.2                 ^| Java 17-21
echo   [15] 1.18.1                 ^| Java 17-21
echo.
echo   [16] 1.17.1                 ^| Java 16-17
echo.
echo   [17] 1.16.5                 ^| Java 16
echo.
echo   [18] ÖZEL SÜRÜM GİR ^(1.16.5-1.21.4^)
echo   [0]  ÇIK
echo.
set "CH="
set /p "CH=Seçiminiz [0-18]: "
if "%CH%"=="0" goto :cleanExit

::  -------- SÜRÜM ATAMALARI --------
if "%CH%"=="1" set "MC=1.21.4" & set "MAX_JAVA=21" & goto :getBuild
if "%CH%"=="2" set "MC=1.21.3" & set "MAX_JAVA=21" & goto :getBuild
if "%CH%"=="3" set "MC=1.21.2" & set "MAX_JAVA=21" & goto :getBuild
if "%CH%"=="4" set "MC=1.21.1" & set "MAX_JAVA=21" & goto :getBuild

if "%CH%"=="5" set "MC=1.20.6" & set "MAX_JAVA=21" & goto :getBuild
if "%CH%"=="6" set "MC=1.20.5" & set "MAX_JAVA=21" & goto :getBuild
if "%CH%"=="7" set "MC=1.20.4" & set "MAX_JAVA=21" & goto :getBuild
if "%CH%"=="8" set "MC=1.20.3" & set "MAX_JAVA=21" & goto :getBuild
if "%CH%"=="9" set "MC=1.20.2" & set "MAX_JAVA=21" & goto :getBuild
if "%CH%"=="10" set "MC=1.20.1" & set "MAX_JAVA=21" & goto :getBuild

if "%CH%"=="11" set "MC=1.19.4" & set "MAX_JAVA=21" & goto :getBuild
if "%CH%"=="12" set "MC=1.19.3" & set "MAX_JAVA=21" & goto :getBuild
if "%CH%"=="13" set "MC=1.19.2" & set "MAX_JAVA=21" & goto :getBuild

if "%CH%"=="14" set "MC=1.18.2" & set "MAX_JAVA=21" & goto :getBuild
if "%CH%"=="15" set "MC=1.18.1" & set "MAX_JAVA=21" & goto :getBuild

if "%CH%"=="16" set "MC=1.17.1" & set "MAX_JAVA=17" & goto :getBuild

if "%CH%"=="17" set "MC=1.16.5" & set "MAX_JAVA=16" & goto :getBuild

if "%CH%"=="18" goto :customVersion
goto :mainMenu

::  ------------------------------------------------------
::  ÖZEL SÜRÜM GİRİŞİ (DESTEKLENEN ARALIK)
::  ------------------------------------------------------
:customVersion
cls
echo.
echo  ==========================================
echo         ÖZEL SÜRÜM SEÇİMİ
echo  ==========================================
echo.
echo  DESTEKLENEN SÜRÜMLER: 1.16.5 - 1.21.4
echo  Örnekler: 1.20.2, 1.19.3, 1.18.1, 1.17.1
echo.
set /p "MC=Özel Paper sürümünü girin (örn 1.20.2): "
if "!MC!"=="" goto :mainMenu

:: **SÜRÜM FORMAT KONTROLÜ (X.X.X)**
echo !MC! | findstr /r "^[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*$" >nul
if !errorlevel! neq 0 (
    echo  [HATA] Geçersiz sürüm formatı! Örnek: 1.20.2
    pause & goto :customVersion
)

:: **SÜRÜM ARALIĞI KONTROLÜ (1.16.5 - 1.21.4)**
for /f "tokens=1,2,3 delims=." %%a in ("!MC!") do (
    set "MAJOR=%%a"
    set "MINOR=%%b"
    set "PATCH=%%c"
)

:: **1.16.5'ten KÜÇÜK mü kontrol et**
if !MAJOR! equ 1 (
    if !MINOR! LSS 16 (
        echo  [HATA] !MC! desteklenmiyor!
        echo  Minimum sürüm: 1.16.5
        pause & goto :customVersion
    )
    if !MINOR! equ 16 (
        if !PATCH! LSS 5 (
            echo  [HATA] !MC! desteklenmiyor!
            echo  Minimum sürüm: 1.16.5
            echo  (1.16.5'ten eski sürümler desteklenmez)
            pause & goto :customVersion
        )
    )
)

:: **1.21.4'ten BÜYÜK mü kontrol et**
if !MAJOR! equ 1 (
    if !MINOR! GTR 21 (
        echo  [HATA] !MC! desteklenmiyor!
        echo  Maksimum sürüm: 1.21.4
        pause & goto :customVersion
    )
    if !MINOR! equ 21 (
        if !PATCH! GTR 4 (
            echo  [HATA] !MC! desteklenmiyor!
            echo  Maksimum sürüm: 1.21.4
            pause & goto :customVersion
        )
    )
)

:: **ÖZEL SÜRÜM İÇİN MAKSİMUM JAVA BELİRLE**
if "!MINOR!" GEQ "21" (
    set "MAX_JAVA=21"
) else if "!MINOR!" GEQ "17" (
    set "MAX_JAVA=17"
) else if "!MINOR!" GEQ "16" (
    set "MAX_JAVA=16"
)

echo  [OK] !MC! sürümü seçildi ^(Max Java: !MAX_JAVA!^)
pause
goto :getBuild

::  ------------------------------------------------------
::  BUILD NUMARASINI AL
::  ------------------------------------------------------
:getBuild
cls & echo. & echo  [PaperMC] En yeni build alınıyor...
set "BUILD="
for /f "delims=" %%b in ('powershell -NoP -C ^
  "$v='!MC!'; try {(irm https://api.papermc.io/v2/projects/paper/versions/$v/builds).builds[-1].build} catch {''}" 2^>nul') do set "BUILD=%%b"

if "%BUILD%"=="" (
    echo  [HATA] '%MC%' için build bulunamadı
    echo  Bu sürüm Paper tarafından desteklenmiyor olabilir
    echo  Lütfen listedeki desteklenen sürümlerden birini seçin
    pause & goto :mainMenu
)

set "URL=https://api.papermc.io/v2/projects/paper/versions/%MC%/builds/%BUILD%/downloads/paper-%MC%-%BUILD%.jar"
echo  [PaperMC] Build %BUILD% bulundu.
>>"%LOG%" echo [%DATE% %TIME%] URL: %URL%

::  ------------------------------------------------------
::  JAVA KONTROL VE KURULUM
::  ------------------------------------------------------
:javaCheck
cls & echo. & echo  [JAVA] Kontrol ediliyor... ^(Max Java: %MAX_JAVA%^)

:: **MEVCUT JAVA VERSİYONUNU KONTROL ET**
set "CURRENT_JAVA=0"
set "JAVA_OK=0"
java -version 2>nul && (
    for /f "tokens=3" %%v in ('java -version 2^>^&1 ^| find "version"') do set "JV=%%v"
    set "JV=!JV:"=!"
    
    for /f "tokens=1,2 delims=." %%a in ("!JV!") do (
        if "%%a"=="1" (
            set "CURRENT_JAVA=%%b"
        ) else (
            set "CURRENT_JAVA=%%a"
        )
    )
    
    echo  [JAVA] Mevcut: Java !CURRENT_JAVA!
    
    :: **MAKSİMUM JAVA'DAN YÜKSEK Mİ KONTROL ET**
    if !CURRENT_JAVA! GTR %MAX_JAVA% (
        echo  [UYARI] Java !CURRENT_JAVA! çok yüksek
        echo  Bu sürüm en fazla Java %MAX_JAVA% destekler
        echo.
        set /p "INSTALL_JAVA=Uygun Java (%MAX_JAVA%) kurulsun mu? (Y/N): "
        if /i "!INSTALL_JAVA!"=="Y" goto :installJava
        set "JAVA_OK=1"
    ) else if !CURRENT_JAVA! GEQ 16 (
        :: **JAVA 16 VEYA ÜSTÜ VE MAKSİMUM SINIRIN ALTINDA İSE OK**
        echo  [OK] Java !CURRENT_JAVA! uygun
        set "JAVA_OK=1"
        goto :folder
    ) else (
        echo  [UYARI] Java !CURRENT_JAVA! yetersiz
        set /p "INSTALL_JAVA=Java %MAX_JAVA% kurulsun mu? (Y/N): "
        if /i "!INSTALL_JAVA!"=="Y" goto :installJava
        echo  [HATA] Java %MAX_JAVA% veya uygun sürüm gerekli & pause & goto :mainMenu
    )
) || (
    echo  [UYARI] Java bulunamadı
    set /p "INSTALL_JAVA=Java %MAX_JAVA% kurulsun mu? (Y/N): "
    if /i "!INSTALL_JAVA!"=="Y" goto :installJava
    echo  [HATA] Java gerekli & pause & goto :mainMenu
)

:: **JAVA UYGUN DEĞİLSE DEVAM ETME SEÇENEĞİ**
if "!JAVA_OK!"=="1" (
    echo.
    echo  [UYARI] Java uygun değil, sunucu çalışmayabilir
    set /p "CONTINUE=Yine de devam etmek istiyor musunuz? (Y/N): "
    if /i "!CONTINUE!"=="Y" goto :folder
    goto :mainMenu
)

::  ------------------------------------------------------
::  JAVA KURULUMU (GÜNCEL LİNKLER)
::  ------------------------------------------------------
:installJava
cls & echo. & echo  [JAVA] Java %MAX_JAVA% kuruluyor... ^(2-3 dk^)

:: **GÜNCEL MSI URL'LERİ - ECLIPSE TEMURIN**
if "%MAX_JAVA%"=="21" (
    set "JAVA_URL=https://github.com/adoptium/temurin21-binaries/releases/download/jdk-21.0.5%%2B11/OpenJDK21U-jdk_x64_windows_hotspot_21.0.5_11.msi"
    set "JAVA_MSI=temurin21.msi"
) else if "%MAX_JAVA%"=="17" (
    set "JAVA_URL=https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.11%%2B9/OpenJDK17U-jdk_x64_windows_hotspot_17.0.11_9.msi"
    set "JAVA_MSI=temurin17.msi"
) else if "%MAX_JAVA%"=="16" (
    set "JAVA_URL=https://github.com/adoptium/temurin16-binaries/releases/download/jdk-16.0.2%%2B7/OpenJDK16U-jdk_x64_windows_hotspot_16.0.2_7.msi"
    set "JAVA_MSI=temurin16.msi"
)

echo  [JAVA] MSI indiriliyor...
set "MSI=%TEMP_DIR%\!JAVA_MSI!"
powershell -NoP -C "Invoke-WebRequest -Uri '!JAVA_URL!' -OutFile '!MSI!'" 2>nul

if not exist "!MSI!" ( 
    echo  [HATA] Java indirilemedi
    echo  Elle indirip kurmanız gerekebilir:
    if "%MAX_JAVA%"=="16" echo  Java 16: https://adoptium.net/temurin/releases/?version=16
    if "%MAX_JAVA%"=="17" echo  Java 17: https://adoptium.net/temurin/releases/?version=17
    if "%MAX_JAVA%"=="21" echo  Java 21: https://adoptium.net/temurin/releases/?version=21
    pause & goto :mainMenu
)

echo  [JAVA] MSI kuruluyor...
msiexec /i "!MSI!" /quiet /norestart
if !errorlevel! neq 0 ( 
    echo  [HATA] Java kurulum hatası & pause & goto :mainMenu 
)

echo  [JAVA] Kurulum tamamlandı, PATH güncelleniyor...
timeout /t 3 >nul

:: **PATH YENİLE**
call :refreshEnv
timeout /t 2 >nul

:: **KONTROL ET**
java -version >nul 2>&1
if !errorlevel! equ 0 (
    echo  [OK] Java %MAX_JAVA% kuruldu
    goto :folder
) else (
    echo  [UYARI] Java kuruldu ama PATH güncellenemedi.
    echo  Programı yeniden başlatın.
    pause & goto :mainMenu
)

::  ------------------------------------------------------
::  KLASÖR SEÇİMİ
::  ------------------------------------------------------
:folder
cls
echo.
echo  [Kurulum] Klasör seçin:
set "DEF=%DESKTOP%\Paper_%MC%_Server"
echo  Varsayılan: %DEF%"
set /p "FOLDER=Değiştirmek ister misiniz? (y/N): "
if /i "%FOLDER%"=="y" set /p "DEF=Yeni tam yol: "
for %%A in ("%DEF%") do set "SERVER=%%~sA"
if exist "%SERVER%" (
    echo  [UYARI] Klasör zaten var!
    set /p "DEL_OLD=Üstüne yazılsın mı? (y/N): "
    if /i "%DEL_OLD%"=="y" rmdir /s /q "%SERVER%"
)
mkdir "%SERVER%" 2>nul || (
    echo  [HATA] Klasör oluşturulamadı & pause & goto :folder
)
cd /d "%SERVER%"
>>"%LOG%" echo [%DATE% %TIME%] Klasör: %SERVER%

::  ------------------------------------------------------
::  PAPER İNDİR
::  ------------------------------------------------------
cls & echo. & echo  [İndirme] Paper %MC% indiriliyor...
powershell -NoP -C "Invoke-WebRequest -Uri '%URL%' -OutFile 'server.jar'"
if not exist "server.jar" (
    echo  [HATA] İndirilemedi & pause & goto :cleanExit
)
>>"%LOG%" echo [%DATE% %TIME%] server.jar indirildi

::  ------------------------------------------------------
::  EULA
::  ------------------------------------------------------
:eula
cls & echo. & echo  [EULA] Minecraft EULA'sını kabul etmelisiniz.
echo  Metin: https://www.minecraft.net/eula
set "EULAANS="
set /p "EULAANS=Kabul ediyor musunuz? (Y/N): "
if /i "%EULAANS%"=="Y" (
    >eula.txt echo eula=true
    >>"%LOG%" echo [%DATE% %TIME%] EULA kabul edildi
    goto :props
)
goto :eula

::  ------------------------------------------------------
::  AYARLAR
::  ------------------------------------------------------
:props
cls & echo. & echo  [RAM] GB cinsinden aralık
set "MIN=2" & set "MAX=8"
set /p "MIN=Minimum (varsayılan 2): "
set /p "MAX=Maximum (varsayılan 8): "
if "%MIN%"=="" set MIN=2
if "%MAX%"=="" set MAX=8
set /a MIN*=1 & set /a MAX*=1
if %MIN% GTR %MAX% (set /a MAX=MIN+2)

echo  [NOT] server.properties ilk çalıştırmada otomatik oluşacak

::  ------------------------------------------------------
::  SÜRÜME ÖZEL START.BAT OLUŞTUR
::  ------------------------------------------------------
cls & echo. & echo  [Dosya] start.bat oluşturuluyor...

:: **MAKSİMUM JAVA'YA GÖRE FLAG'LER**
if "%MAX_JAVA%"=="21" (
    set "JAVA_FLAGS=--add-modules=jdk.incubator.vector -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:MaxTenuringThreshold=1 -XX:+PerfDisableSharedMem -Dusing.aikars.flags=https://mcflags.emc.gs/ -Daikars.new.flags=true -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15"
) else if "%MAX_JAVA%"=="17" (
    set "JAVA_FLAGS=-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:MaxTenuringThreshold=1 -XX:+PerfDisableSharedMem -Dusing.aikars.flags=https://mcflags.emc.gs/ -Daikars.new.flags=true -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=15"
) else if "%MAX_JAVA%"=="16" (
    set "JAVA_FLAGS=-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:MaxTenuringThreshold=1 -XX:+PerfDisableSharedMem -Dusing.aikars.flags=https://mcflags.emc.gs/ -Daikars.new.flags=true -XX:G1NewSizePercent=25 -XX:G1MaxNewSizePercent=35 -XX:G1HeapRegionSize=4M -XX:G1ReservePercent=15"
)

>start.bat (
echo :start
echo java -Xms%MIN%G -Xmx%MAX%G !JAVA_FLAGS! -jar server.jar --nogui
echo.
echo Sunucu kapatıldı. Çıkmak için bir tuşa basın...
echo pause ^>nul
)

:: **KONTROL ET**
if not exist "start.bat" (
    echo  [HATA] start.bat oluşturulamadı!
    pause & goto :cleanExit
)

echo  [OK] start.bat başarıyla oluşturuldu
>>"%LOG%" echo [%DATE% %TIME%] start.bat oluşturuldu

::  ------------------------------------------------------
::  FIREWALL KURALI (İSTEĞE BAĞLI)
::  ------------------------------------------------------
cls
echo.
echo  [Firewall] Dış bağlantı için 25565 portunu açmak ister misiniz?
echo.
set /p "FIREWALL= (Y/N, varsayılan N): "
if /i "%FIREWALL%"=="Y" (
    echo  [Güvenlik] Windows Firewall'a 25565 portu ekleniyor...
    netsh advfirewall firewall add rule name="PaperMC %MC%" dir=in action=allow protocol=TCP localport=25565 >nul 2>&1
    netsh advfirewall firewall add rule name="PaperMC %MC%" dir=out action=allow protocol=TCP localport=25565 >nul 2>&1
    >>"%LOG%" echo [%DATE% %TIME%] Firewall kuralları eklendi
    echo  [OK] Firewall kuralları eklendi
)

::  ------------------------------------------------------
::  README OLUŞTUR
::  ------------------------------------------------------
>README.txt (
echo Paper %MC% Sunucu Kurulumu
echo ============================
echo.
echo DESTEKLENEN MAKSİMUM JAVA: %MAX_JAVA%
echo RAM: %MIN%GB - %MAX%GB
echo PORT: 25565
echo.
echo 1) Sunucuyu başlatmak için:
echo    - Klasöre gidin: %SERVER%
echo    - "start.bat" dosyasına ÇİFT TIKLAYIN
echo.
echo 2) Java %MAX_JAVA% veya daha düşük sürüm gerekir
echo.
echo 3) İlk çalıştırma 1-5 dakika sürebilir
echo.
echo İYİ EĞLENCELER!
)

::  ------------------------------------------------------
::  BİTİŞ
::  ------------------------------------------------------
cls
echo.
echo   ===========================================
echo      KURULUM TAMAMLANDI!
echo   ===========================================
echo.
echo   Minecraft: Paper %MC%
echo   Max Java: %MAX_JAVA%
echo   RAM: %MIN%GB - %MAX%GB
echo   Klasör: %SERVER%
echo.
echo   1) "start.bat" dosyasına ÇİFT TIKLAYIN
echo   2) localhost:25565 ile bağlanın
echo.
>>"%LOG%" echo [%DATE% %TIME%] Kurulum tamamlandı

:: **KLASÖRÜ AÇ**
echo.
set /p "OPEN=Sunucu klasörünü açmak ister misiniz? (Y/N, varsayılan Y): "
if /i "%OPEN%"=="N" goto :noOpen
if /i "%OPEN%"=="" set "OPEN=Y"
if /i "%OPEN%"=="Y" explorer "%SERVER%"
:noOpen

echo.
echo   Herhangi bir tuşa basarak çıkabilirsiniz...
pause >nul

::  ------------------------------------------------------
::  TEMİZ ÇIKIŞ
::  ------------------------------------------------------
:cleanExit
if exist "%TEMP_DIR%" rd /s /q "%TEMP_DIR%" 2>nul
exit /b 0

::  ------------------------------------------------------
::  ORTAM DEĞİŞKENLERİNİ YENİDEN YÜKLE
::  ------------------------------------------------------
:refreshEnv
for /f "tokens=*" %%a in ('reg query "HKCU\Environment" 2^>nul ^| findstr /i "Path"') do (
    for /f "tokens=1,2* delims= " %%b in ("%%a") do (
        if /i "%%b"=="Path" (
            set "USER_PATH=%%d"
        )
    )
)

for /f "tokens=*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" 2^>nul ^| findstr /i "Path"') do (
    for /f "tokens=1,2* delims= " %%b in ("%%a") do (
        if /i "%%b"=="Path" (
            set "SYSTEM_PATH=%%d"
        )
    )
)

if defined USER_PATH set "PATH=%USER_PATH%;%SYSTEM_PATH%"
if not defined USER_PATH set "PATH=%SYSTEM_PATH%"

exit /b
