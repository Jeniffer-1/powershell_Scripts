function Start-ProgressBar{ #Se crea una función llamada Start-ProgressBar.
    [CmdletBinding()] # Permite que la función se comporte como un cmdlet avanzado (por ejemplo, habilita validación y compatibilidad con el sistema de ayuda).
    param(
        [Parameter(Mandatory = $true)] #  La función recibe dos parámetros obligatorios:
        $Title,  # $Title → texto que se mostrará como el título de la barra de progreso.
        
        [Parameter(Mandatory = $true)]
        [int]$Timer   # $Timer (int) → número de iteraciones (segundos) que durará la barra de progreso.
    )

    for ($i = 1; $i -le $Timer; $i++) { # El bucle se ejecuta desde 1 hasta el valor de $Timer
        Start-Sleep -Seconds 1;  # Cada iteración espera 1 segundo, simulando un "temporizador".
        $percentComplete = ($i / $Timer) * 100
        Write-Progress -Activity $Title -Status "$i seconds elapsed" -PercentComplete $percentComplete # -Status muestra el número actual (iteración).  -Activity muestra el título.  -Percent Complete indica el progreso.   ($i /100 *100) calcula i.
    }
} #Function Start-ProgressBar

#Call the function
Start-ProgressBar -Title "Test timeout" -Timer 30