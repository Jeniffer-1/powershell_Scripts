# script3.ps1
function New-FolderCreation { #Crea una función llamada New-FolderCreation.
     
    [CmdletBinding()] #Permite que la función se comporte como un cmdlet avanzado (admite parámetros profesionales).
    param(  #Indica que vienen los parámetros de entrada.
        [Parameter(Mandatory = $true)] #Hace que el parámetro sea obligatorio.
        [string]$foldername #Define una variable llamada $foldername que deberá ser un texto (string).
    )

    # Create absolute path for the folder relative to current location
    $logpath = Join-Path -Path (Get-Location).Path -ChildPath $foldername #La ruta actual,Con el nombre de la carpeta y crea la ruta completa de la nueva carpeta.
    if (-not (Test-Path -Path $logpath)) { #Verifica si NO existe la carpeta.
        New-Item -Path $logpath -ItemType Directory -Force | Out-Null #si no existe la crea como carpeta No muestra mensajes en pantalla.
    }

    return $logpath
}

function Write-Log {  #Crea la función principal llamada Write-Log.
    [CmdletBinding()] #Permite usar parámetros avanzados.
    param(
        # Create parameter set
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')] #Este parámetro es obligatorio solo en el modo Create.
        [Alias('Names')]  #Permite usar también el nombre -Names en lugar de -Name.
        [object]$Name,                     # resive un solo nombre O varios nombres de archivo.
        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$Ext, #Obligatorio en modo Create.Define la extensión del archivo (log, txt).

        [Parameter(Mandatory = $true, ParameterSetName = 'Create')]
        [string]$folder, #Indica el nombre de la carpeta donde se guardará el log.

        [Parameter(ParameterSetName = 'Create', Position = 0)]
        [switch]$Create, #Activa el modo de creación de archivos.

        # Message parameter set
        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$message, #Mensaje que se escribirá en el archivo log.

        [Parameter(Mandatory = $true, ParameterSetName = 'Message')]
        [string]$path, #Ruta donde se escribirá el mensaje.

        [Parameter(Mandatory = $false, ParameterSetName = 'Message')]
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information', #Restringe el tipo de mensaje a solo esos 3 valores.Si no se especifica, usa Information.

        [Parameter(ParameterSetName = 'Message', Position = 0)]
        [switch]$MSG #Activa el modo de escritura de mensajes.
    )

    switch ($PsCmdlet.ParameterSetName) { #Detecta si el usuario activó Create o Message
        "Create" { #Entra al modo creación de archivo.
            $created = @() #Crea un arreglo vacío donde se guardarán las rutas creadas.

            # Normalize $Name to an array
            $namesArray = @()
            if ($null -ne $Name) { #Verifica si el parámetro Name tiene valor.
                if ($Name -is [System.Array]) { $namesArray = $Name } #Si Name es un arreglo → lo usa.
                else { $namesArray = @($Name) } #Si solo es un valor → lo convierte en arreglo.
            }

            # Date + time formatting (safe for filenames)
            $date1 = (Get-Date -Format "yyyy-MM-dd") #Obtiene la fecha actual.
            $time  = (Get-Date -Format "HH-mm-ss") #Obtiene la hora actual.

            # Ensure folder exists and get absolute folder path
            $folderPath = New-FolderCreation -foldername $folder #Llama a la función que crea la carpeta.

            foreach ($n in $namesArray) { #Recorre cada nombre del arreglo.
                # sanitize name to string
                $baseName = [string]$n #Convierte el nombre a texto.

                # Build filename
                $fileName = "${baseName}_${date1}_${time}.$Ext" #Construye el nombre completo del archivo.

                # Full path for file
                $fullPath = Join-Path -Path $folderPath -ChildPath $fileName #Une la carpeta con el nombre del archivo.

                try {
                
                    New-Item -Path $fullPath -ItemType File -Force -ErrorAction Stop | Out-Null #Crea el archivo log.Si hay error se detiene.


                    $created += $fullPath #Guarda la ruta del archivo creado.
                }
                catch { #Captura errores si el archivo falla.
                    Write-Warning "Failed to create file '$fullPath' - $_" #Muestra advertencia.
                }
            }

            return $created
        }

        "Message" { #Entra al modo escribir mensaje.
            # Ensure directory for message file exists
            $parent = Split-Path -Path $path -Parent #Extrae solo la carpeta del archivo.
            if ($parent -and -not (Test-Path -Path $parent)) {  #Si la carpeta no existe
                New-Item -Path $parent -ItemType Directory -Force | Out-Null #la crea automáticamente.
            }

            $date = Get-Date #Obtiene fecha y hora.
            $concatmessage = "|$date| |$message| |$Severity|" #Construye el mensaje con formato de registro.

            switch ($Severity) {
                "Information" { Write-Host $concatmessage -ForegroundColor Green } #Muestra el mensaje en verde.
                "Warning"     { Write-Host $concatmessage -ForegroundColor Yellow } #Muestra en amarillo.
                "Error"       { Write-Host $concatmessage -ForegroundColor Red } #Muestra en rojo.
            }

            # Append message to the specified path (creates file if it does not exist)
            Add-Content -Path $path -Value $concatmessage -Force #Guarda el mensaje dentro del archivo.
 
            return $path
        }

        default {
            throw "Unknown parameter set: $($PsCmdlet.ParameterSetName)" #Lanza error si se usa un modo inválido.
        }
    }
}

# ---------- Example usage ----------
# This will create the folder "logs" (if missing) and create a file Name-Log_YYYY-MM-DD_HH-mm-ss.log
$logPaths = Write-Log -Name "Name-Log" -folder "logs" -Ext "log" -Create #Crea el archivo log dentro de la carpeta logs.
$logPaths #Muestra la ruta completa del archivo creado.
