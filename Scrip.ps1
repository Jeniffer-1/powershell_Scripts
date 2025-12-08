function Start-ProgressBar{ 
    [CmdletBinding()] # Hace que la función se comporte como un cmdlet avanzado(por ejemplo, habilita validación y compatibilidad con el sistema de ayuda).
    param(
        [Parameter(Mandatory = $true)] #  La función recibe dos parámetros obligatorios:
        $Title, #Parámetro obligatorio Title (título de la barra de progreso).
        
        [Parameter(Mandatory = $true)]
        [int]$Timer   # $Timer (int) → número de iteraciones (segundos) que durará la barra de progreso.Parámetro obligatorio Timer, tipo entero (cantidad de segundos).
    )

    for ($i = 1; $i -le $Timer; $i++) { # El bucle se ejecuta desde 1 hasta el valor de $Timer
        Start-Sleep -Seconds 1;  # Cada iteración espera 1 segundo, simulando un "temporizador".Espera 1 segundo por cada iteración.
        $percentComplete = ($i / $Timer) * 100 #Calcula el porcentaje de progreso.
        Write-Progress -Activity $Title -Status "$i seconds elapsed" -PercentComplete $percentComplete # Actualiza la barra de progreso con:actividad (título),estado (segundos transcurridos),porcentaje completado
}   }     #Call the function
Start-ProgressBar -Title "Test timeout" -Timer 30  #Ejecuta la función con título “Test timeout” por 30 segundos.