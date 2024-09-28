; ---------------------------------------
; Verificar Ejecucion de Programa
; (c) 2024 RicardoPonce
;
; Examina los procesos activos en Windows
; y alerta cuando un programa específico
; comienza a funcionar
;
; https://profesorponce.blogspot.com/
;
; Código en [PureBasic 6.02] 
; ---------------------------------------

; Articulo original en LinkedIN:
; https://www.linkedin.com/pulse/monitorea-la-seguridad-de-tu-equipo-ricardo-daniel-ponce-iqswf

#TH32CS_SNAPPROCESS = $00000002

; Definir el nombre del programa a monitorear
Global programName$ = "notepad.exe" ; Cambia esto al nombre del programa que deseas monitorear
#INTERVAL = 5                       ; Intervalo en segundos para verificar la ejecución

Procedure ExamineTaskList()
  Protected ProcessEntry.PROCESSENTRY32
  Protected Snapshot
  
  ProcessEntry\dwSize = SizeOf(PROCESSENTRY32)
  Snapshot = CreateToolhelp32Snapshot_(#TH32CS_SNAPPROCESS, 0)
  
  If Snapshot <> #INVALID_HANDLE_VALUE
    If Process32First_(Snapshot, @ProcessEntry)
      Repeat
        ; nombre del proceso y el PID (si desea verlos, elimine el caracter ; de comentario
        ;Debug "Proceso: " + PeekS(@ProcessEntry\szExeFile) + " - PID: " + Str(ProcessEntry\th32ProcessID)
        If Trim(LCase(PeekS(@ProcessEntry\szExeFile))) = programName$
           MessageRequester ("ATENCION", "Programa "+programName$+" en ejecución", #PB_MessageRequester_Warning)
        EndIf
        
      Until Process32Next_(Snapshot, @ProcessEntry) = 0
    Else
      Debug "No se pudo obtener el primer proceso."
    EndIf
    CloseHandle_(Snapshot)
  Else
    Debug "No se pudo crear el snapshot de los procesos."
  EndIf
EndProcedure

; Bucle para monitorear la ejecución del programa en intervalos regulares
While #True
  ExamineTaskList()
  
  Delay(#INTERVAL * 1000) ; Esperar el intervalo antes de volver a comprobar
Wend



End   

; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; CursorPosition = 22
; FirstLine = 3
; Folding = -
; EnableXP