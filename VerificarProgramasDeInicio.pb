; ---------------------------------------
; Verificar Programas de Inicio
; (c) 2024 RicardoPonce
;
; Verifica los programas que inician
; con Windows declarados en las
; claves del registro
;
; https://profesorponce.blogspot.com/
;
; Código en [PureBasic 6.02] 
; ---------------------------------------
;
; Para comprobar qué programas se ejecutan al 
; iniciar el sistema (un área que muchos malware 
; utilizan), puedes acceder a las claves de 
; registro de Windows o los archivos de 
; configuración en otros sistemas operativos.
; Este código inspecciona las claves de registro 
; donde se almacenan los programas que se ejecutan 
; automáticamente al inicio de Windows. Puedes 
; revisar estos programas para ver si algo no 
; es familiar. Las claves revisadas son las de 
; RUN en #HKLM (para todos los usuarios) y 
; #HKCU (para el usuario actual que ha iniciado 
; la sesión de trabajo). 
; El método de lectura de claves y variables de 
; registro implementa el uso de funciones de la 
; API de Windows y en realidad, este código de 
; lectura de claves y variables se puede usar 
; para leer cualquier clave, variable y contenido 
; del registro de windows. Si te interesa hacerlo, 
; te aconsejo que te documentes con AUTORUNS de 
; Sysinternals:  
; https://learn.microsoft.com/es-es/sysinternals/downloads/autoruns
; o algún otro programa similar para explorar 
; exhaustivamente las configuraciones del registro.

; Articulo original en LinkedIN:
; https://www.linkedin.com/pulse/monitorea-la-seguridad-de-tu-equipo-ricardo-daniel-ponce-iqswf

#HKEY_LOCAL_MACHINE = $80000002
#HKEY_CURRENT_USER = $80000001

Procedure EnumerateStartupPrograms(hKey, keyPath$)
  Protected hKeyOpened
  Protected valueName$ = Space(255)
  Protected valueData$ = Space(255)
  Protected valueNameLength
  Protected valueDataLength
  Protected index = 0
  
  ; Abrir la clave del registro en la ruta proporcionada
  If RegOpenKeyEx_(hKey, keyPath$, 0, #KEY_READ, @hKeyOpened) = #ERROR_SUCCESS
    Debug " "
    Debug "Programas de inicio en: " + keyPath$
    Debug " "
    ; Enumerar las entradas en la clave del registro
    Repeat
      valueNameLength = 255
      valueDataLength = 255
      
      ; Leer cada valor en la clave
      If RegEnumValue_(hKeyOpened, index, @valueName$, @valueNameLength, 0, 0, @valueData$, @valueDataLength) = #ERROR_SUCCESS
        Debug "Programa: " + PeekS(@valueName$, valueNameLength) + " -> " + PeekS(@valueData$, valueDataLength)
        index + 1
      Else
        Break
      EndIf
    ForEver
    
    ; Cerrar la clave del registro
    RegCloseKey_(hKeyOpened)
  Else
    Debug "No se pudo abrir la clave del registro: " + keyPath$
  EndIf
EndProcedure

; Leer los programas de inicio de HKEY_LOCAL_MACHINE
EnumerateStartupPrograms(#HKEY_LOCAL_MACHINE, "SOFTWARE\Microsoft\Windows\CurrentVersion\Run")

; Leer los programas de inicio de HKEY_CURRENT_USER
EnumerateStartupPrograms(#HKEY_CURRENT_USER, "SOFTWARE\Microsoft\Windows\CurrentVersion\Run")

End


; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; CursorPosition = 40
; FirstLine = 10
; Folding = -
; EnableXP