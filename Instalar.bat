@echo off
setlocal

echo Buscando Tu Particion EFI...

rem Para Detectar la particion EFI busca estas etiquetas, puede variar por Idioma, agrega Sistema en tu idioma puede resolver en EFI no Encontrado.
set "labels=ESP EFI System Sistema "

set "EFI_VOLUME="

for %%l in (%labels%) do (
    for /f "tokens=2 delims= " %%i in ('echo list volume ^| diskpart ^| findstr /i "%%l"') do (
        set "EFI_VOLUME=%%i"
    )
    if not "%EFI_VOLUME%"=="" goto :found
)

:found
if "%EFI_VOLUME%"=="" (
    echo No he encontrado una particion EFI.
    pause
    exit /b 1
)

echo EFI en: %EFI_VOLUME%

rem Agregar S a la partición EFI, se puede cambiar.
(
    echo select volume %EFI_VOLUME%
    echo assign letter=S
) | diskpart > nul 2>&1

if %errorlevel% neq 0 (
    echo Error. Al Parecer la letra S ya esta en uso en alguna Unidad. Desactiva la Unidad S y Vuelve a Ejecutar este Script.
    pause
    exit /b %errorlevel%
)

if exist "S:\EFI\refind" (
    rd /s /q "S:\EFI\refind"
)

echo Instalando rEFInd...

xcopy /E /I /Y "C:\rEFIndAjustes\refind" "S:\EFI\refind" > nul 2>&1

if %errorlevel% neq 0 (
    echo Error en la copia. Es Probable que la Carpeta "C:\rEFIndAjustes\refind" no Exista. Ahora la Particion EFI es visible en tu Equipo, Muevelo Manualmente. No Borres Nada de lo que ya hay ahi o tu PC ya no encendera...
    pause
    exit /b %errorlevel%
)

echo Ajustando para iniciar rEFInd al encender la PC...

bcdedit /set {bootmgr} path \EFI\refind\refind_x64.efi > nul 2>&1

if %errorlevel% neq 0 (
    echo Error al ejecutar bcdedit. Usa CMD como Administrador y no en PowerShell...
    pause
    exit /b %errorlevel%
)

rem Volver a ocultar la partición EFI
(
    echo select volume %EFI_VOLUME%
    echo remove letter=S
) | diskpart > nul 2>&1

if %errorlevel% neq 0 (
    echo Error ocultando particion EFI. Lamentablemente veras una Nueva unidad en el Inicio, Desde Ahi Puedes instalar rEFInd Manualmente moviendo la Carpeta a EFI/EFI. NO BORRES NADA DE ESA UNIDAD O TU PC YA NO ENCENDERA.
    pause
    exit /b %errorlevel%
)

echo.
echo ##############################################################
echo #                Instalacion Completa \:D/                   #
echo #           Si Tienes SecureBoot no Sucedera Nada            #
echo #              Reiniciar la PC para Probarlo.                #
echo #                                                            #
echo #                 Pulsa ENTER para Salir                     #
echo ##############################################################
echo.

pause >nul
endlocal
exit /b 0
