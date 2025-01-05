@echo off
color 02
echo $=================================$
echo    [ LIMPANDO CACHE, AGUARDE! ]     
echo $=================================$
rd /s /q "cache"
test&cls
color 02
pause
echo $=================================$
echo     [ Base Unity - Clean v3.0.2 ] 	
echo $=================================$
..\artifacts\FXServer.exe +exec config\config.cfg  +set sv_enforceGameBuild 2612 +set svgui_disable true +set onesync_population false
exit