param(
    # Script to execute
    [string]$Script,
    [string]$PythonVersion = "3",
    [string]$EnvDir = ".venv",
    [bool]$getpyhonpath = $false
)


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
        $path = Resolve-Path $this.EnvDir -ErrorAction Stop
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

    [void] RunScript($Script) {
        $ScriptPath = Resolve-Path $Script -ErrorAction Stop
        $this.Activate()
        Invoke-Expression $ScriptPath
        $this.Deactivate()
    }

    [string] GetPythonExe() {
        $this.Activate()
        $PythonPath = $(py -c "import sys; print(f'{sys.exec_prefix}')") + "\Scripts\python.exe"
        $this.Deactivate()
        return $PythonPath
    }
    
    [void]Remove() {
        $this.Deactivate()
        Write-Host "Removing virtual environment in $($this.EnvAbsPath)"
        Remove-Item $this.EnvAbsPath -Recurse
    }
}




# $ScriptPath = Resolve-Path $Script
[Venv]$MyVenv = [Venv]::new($PythonVersion, $EnvDir)


if ($Script) {
    $MyVenv.RunScript($Script)
}
if ($getpyhonpath) {
    return $MyVenv.GetPythonExe()
}
# $MyVenv.Activate()
# Invoke-Expression $ScriptPath
# Start-Sleep(2)
# $this.Deactivate()
# $MyVenv.Remove()