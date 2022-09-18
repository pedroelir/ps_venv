function New-Venv {
    param (
        $PythonVersion = 3,
        $EnvDir
    )
    Write-Host "Creating virtual environment in $($EnvDir)"
    Invoke-Expression "py -$PythonVersion -m venv $EnvDir"
}
function Set-Venv {
    param (
        $EnvDir
    )
    Write-Host "Activating virtual environment"
    Invoke-Expression $EnvDir\Scripts\Activate.ps1
    Write-Host "Virtual environment activated"
}

function Reset-Venv {
    try {
        Write-Host "Deactivating virtual environment"
        Invoke-Expression deactivate
        Write-Host "Virtual environment deactivated"
    }
    catch [System.Management.Automation.CommandNotFoundException] {
        Write-Host "Virtual environment already deactivated"
    }
}
function Remove-Venv {
    param (
        $EnvDir
    )
    Write-Host "Removing virtual environment in $($EnvDir)"
    Remove-Item $EnvDir -Recurse
}

$EnvDir = "venv"
$PythonVersion = 3.8
$Script = ".\say_hello.ps1"

New-Venv -PythonVersion $PythonVersion -EnvDir $EnvDir
Set-Venv -EnvDir $EnvDir
Start-Sleep(2)
Invoke-Expression $Script
Start-Sleep(2)
Reset-Venv -EnvDir $EnvDir
Start-Sleep(2)
Remove-Venv -EnvDir $EnvDir