
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
        $path = Resolve-Path "$($this.EnvDir)\Scripts\Activate.ps1"
        if ($path -is [System.Management.Automation.PathInfo]) {
            $path = Resolve-Path $this.EnvDir -ErrorAction Stop
            Write-Host "Virtualenv already exists, Using existing virtualenv"
            return $path
        }
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
        Write-Host $(Invoke-Expression $ScriptPath)
        $this.Deactivate()
    }

    [string] GetPythonExe() {
        $this.Activate()
        $PythonPath = $(Get-Command python).Source
        $this.Deactivate()
        return $PythonPath
    }

    [string] GetPipExe() {
        $this.Activate()
        $PythonPath = $(Get-Command pip).Source
        $this.Deactivate()
        return $PythonPath
    }
    
    [void]Remove() {
        $this.Deactivate()
        Write-Host "Removing virtual environment in $($this.EnvAbsPath)"
        Remove-Item $this.EnvAbsPath -Recurse
    }
}



function GetPythonExe {
    param (
        $PythonVersion = "3",
        $EnvDir = ".venv"
    )
    [Venv]$MyVenv = [Venv]::new($PythonVersion, $EnvDir)
    return $MyVenv.GetPythonExe()
}

function GetPipExe {
    param (
        $PythonVersion = "3",
        $EnvDir = ".venv"
    )
    [Venv]$MyVenv = [Venv]::new($PythonVersion, $EnvDir)
    return $MyVenv.GetPipExe()
}

function Use-Python {
    param (
        [string]$default_python = "3.10"
    )
    <#
        .SYNOPSIS
        Check the use of the specified python Version

        .DESCRIPTION
        Checks if python is installed.
        If it is installed it checks if the version mayor and minor is greater or equal to the default version provided.
        If the Python version is not provided, message is return htat it is not install.
        Further implementation can add Downloading and installing python

        .PARAMETER default_python
        Specify the Python version to use

        .EXAMPLE
        PS> Use-Python "3.11"
        3.10.6150.1013
        Python 3.10 not installed. How dare you???? Now installing against your will!!!!!!

        .EXAMPLE
        PS> Use-Python -default_python "3.10"
        3.10.6150.1013
        3.10.6150.1013 is a valid version greater or equal to 3.10

    #>
    
    $expected_py_ver = $default_python.Split(".")
    $expected_py_ver_mayor = [int]$expected_py_ver[0]
    $expected_py_ver_minor = [int]$expected_py_ver[1]

    $_pythonobj = Get-Command python -ErrorAction SilentlyContinue
    # Write-Host $_pythonobj.Version
    if ($_pythonobj -isnot [System.Management.Automation.CommandInfo]) {
        Write-Host "NOOO"
        Write-Host "Python $default_python not installed. How dare you???? Now installing against your will!!!!!!"
    }
    else {
        Write-Host $_pythonobj.Version
        if (($_pythonobj.Version.Major -ge $expected_py_ver_mayor) -and ($_pythonobj.Version.Minor -ge $expected_py_ver_minor)) {
            Write-Host "$($_pythonobj.Version) is a valid version greater or equal to $default_python"
        }
        else {
            Write-Host "Python $default_python not installed. How dare you???? Now installing against your will!!!!!!"
        }
    }

}
