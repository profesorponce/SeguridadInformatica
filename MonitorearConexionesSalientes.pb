; ---------------------------------------
; Monitorear Conexiones Salientes
; (c) 2024 RicardoPonce
;
; Script en PureBasic que monitorea las 
; conexiones salientes y genere una 
; alerta si hay tráfico en la red
;
; https://profesorponce.blogspot.com/
;
; Código en [PureBasic 6.02] 
; ---------------------------------------
;
; Este programas corren el comando netstat 
; para verificar las conexiones salientes
; del sistema, corriendo en RAM permanentemente 
; y rastreando la existencia de conexiones OUT
; de programas mientras mantienen informado 
; al usuario de la computadora. 
; Para 'descolgar' o 'parar' los procesos de 
; memoria, deberá buscarlos en RAM con el 
; administrador de tareas y finalizar el proceso
; Son programas de ejemplo para expertos en 
; seguridad y no están, por lo tanto completamente 
; terminados. Faltaría agregar las rutinas para 
; que los programas se inserten en la barra de 
; tareas de windows para poder pararlos mediante 
; algún botón o cerrando la ventana principal.

; Articulo original en LinkedIN:
; https://www.linkedin.com/pulse/monitorea-la-seguridad-de-tu-equipo-ricardo-daniel-ponce-iqswf

#INTERVAL = 5 ; Intervalo en segundos para verificar las conexiones

Procedure MonitorOutgoingConnections()
  Protected program
  Protected output$
  Protected connectionsCount = 0
  
  ; Ejecutar el comando netstat
  program = RunProgram("netstat", "-an", "", #PB_Program_Open | #PB_Program_Read | #PB_Program_Error)
  
  If program
    ; Leer la salida del comando
    While ProgramRunning(program)
      While AvailableProgramOutput(program)
        output$ = ReadProgramString(program)
        
        ; Verificar si hay conexiones salientes (estado ESTABLISHED)
        If FindString(output$, "ESTABLISHED") > 0
          connectionsCount + 1
          Debug "Conexión saliente detectada: " + output$
        EndIf
      Wend
    Wend
    
    CloseProgram(program)
  Else
    Debug "No se pudo ejecutar el comando netstat."
  EndIf
  
  ; Alertar si hay conexiones salientes
  If connectionsCount > 0
    Debug "¡Alerta! Se detectaron " + Str(connectionsCount) + " conexiones salientes."
  Else
    Debug "No se detectaron conexiones salientes."
  EndIf
EndProcedure

; Bucle para monitorear las conexiones en intervalos regulares
While #True
  MonitorOutgoingConnections()
  Delay(#INTERVAL * 1000) ; Esperar el intervalo antes de volver a comprobar
Wend

End


; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; CursorPosition = 28
; FirstLine = 3
; Folding = -
; EnableXP