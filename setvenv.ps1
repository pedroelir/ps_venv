class Venv {
    [string]$PythonVersion
    [string]$EnvDir
    [string]$EnvAbsPath
    
    Venv($PythonVersion = "3", $EnvDir = ".venv") {
        $this.PythonVersion = $PythonVersion
        $this.EnvDir = $EnvDir
        $this.EnvAbsPath = $this.Create()
        Write-Host "Virtual environment in $($this.EnvAbsPath)"
    }

    [string]Create() {
        Write-Host "Creating virtual environment in $($this.EnvDir)"
        $cmd = "py -$($this.PythonVersion) -m venv $($this.EnvDir)"
        Invoke-Expression $cmd
        $path = Resolve-Path $this.EnvDir
        return $path
    }

    [void]Activate() {
        Write-Host "Activating virtual environment in  $($this.EnvAbsPath)"
        $cmd = "$($this.EnvAbsPath)\Scripts\Activate.ps1"
        Invoke-Expression $cmd
        Write-Host "Virtual environment activated"
    }

    [void]Deactivate() {
        try {
            Write-Host "Deactivating virtual environment"
            Invoke-Expression deactivate
            Write-Host "Virtual environment deactivated"
        }
        catch [System.Management.Automation.CommandNotFoundException] {
            Write-Host "Virtual environment already deactivated"
        }
    }

    [void]Remove() {
        $this.Deactivate()
        Write-Host "Removing virtual environment in $($this.EnvAbsPath)"
        Remove-Item $this.EnvAbsPath -Recurse
    }
}


# }

$EnvDir = ".venv"
$PythonVersion = "3.8"
$Script = ".\say_hello.ps1"



[Venv]$MyVenv = [Venv]::new($PythonVersion, $EnvDir)
$MyVenv.Activate()
Invoke-Expression $Script
Start-Sleep(2)
$MyVenv.Remove()