; ---------------------------------------
; ExamineTaskList
; (c) 2024 RicardoPonce
;
; Listar los procesos en ejecución en Windows 
; utilizando API nativa
;
; https://profesorponce.blogspot.com/
;
; Código en [PureBasic 6.02] 
; ---------------------------------------

; Puedes listar los procesos activos en tu sistema 
; y verificar si hay algo sospechoso o que no 
; reconozcas. PureBasic proporciona una manera de 
; interactuar con el sistema operativo para obtener 
; información sobre procesos. En este código he 
; implementado una función llama EXAMINETASKLIST
; Este código generará en pantalla una lista de 
; procesos activos, incluyendo su nombre y PID 
; (identificador de proceso). Puedes verificar 
; manualmente si algún proceso parece sospechoso.

; Articulo original en LinkedIN:
; https://www.linkedin.com/pulse/monitorea-la-seguridad-de-tu-equipo-ricardo-daniel-ponce-iqswf

#TH32CS_SNAPPROCESS = $00000002


Procedure ExamineTaskList()
  Protected ProcessEntry.PROCESSENTRY32
  Protected Snapshot
  
  ProcessEntry\dwSize = SizeOf(PROCESSENTRY32)
  Snapshot = CreateToolhelp32Snapshot_(#TH32CS_SNAPPROCESS, 0)
  
  If Snapshot <> #INVALID_HANDLE_VALUE
    If Process32First_(Snapshot, @ProcessEntry)
      Repeat
        ; Imprime el nombre del proceso y el PID
        Debug "Proceso: " + PeekS(@ProcessEntry\szExeFile) + " - PID: " + Str(ProcessEntry\th32ProcessID)
      Until Process32Next_(Snapshot, @ProcessEntry) = 0
    Else
      Debug "No se pudo obtener el primer proceso."
    EndIf
    CloseHandle_(Snapshot)
  Else
    Debug "No se pudo crear el snapshot de los procesos."
  EndIf
EndProcedure

; Llamar a la función para listar los procesos
ExamineTaskList()

End   

; IDE Options = PureBasic 6.02 LTS (Windows - x64)
; CursorPosition = 25
; FirstLine = 11
; Folding = -
; EnableXP
; Executable = ExamineTaskList.exe