; ---------------------------------------
; Verificar Conexiones de Red Activas
; (c) 2024 RicardoPonce
; Examina las conexiones de red 
; activas en Windows
; https://profesorponce.blogspot.com/
;
; Código en [PureBasic 6.02] 
; ---------------------------------------
;
; Puedes revisar las conexiones de red activas 
; para ver si hay conexiones no reconocidas que 
; podrían ser intentos maliciosos de acceder a 
; tu máquina. Para hacerlo, puedes usar una 
; combinación de comandos del sistema y leer 
; la salida en PureBasic.
; Con muy pequeñAs modificacinones, puedes 
; implementar un listado de direcciones IP 
; remotas para que el mismo programa te envie 
; una alerta indicando que una IP NO AUTORIZADA 
; ha establecido comunicación con tu equipo.

; Articulo original en LinkedIN:
; https://www.linkedin.com/pulse/monitorea-la-seguridad-de-tu-equipo-ricardo-daniel-ponce-iqswf

Procedure CheckActiveConnections()
  Define program = RunProgram("netstat", "-an", "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Error)

  If program
    ; Mientras el programa sigue en ejecución o aún quedan líneas por leer
    While ProgramRunning(program) Or AvailableProgramOutput(program)
      
      ; Lee las líneas de salida estándar
      While AvailableProgramOutput(program)
        Define output$ = ReadProgramString(program)
        Debug output$
      Wend

    Wend
    
    CloseProgram(program)
  Else
    Debug "No se pudo ejecutar el comando netstat."
  EndIf
EndProcedure

; Llamar a la función para verificar conexiones activas
CheckActiveConnections()

End
; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; CursorPosition = 24
; FirstLine = 7
; Folding = -
; EnableXP