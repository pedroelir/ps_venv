# Run script wrapped with an virtual env

Run the Script to create a virtual env and get the python.exe folder

```ps
.\setvenv.ps1 -PythonVersion 3.8 -EnvDir .venv -getpyhonpath $true
```

Run the Script to run another script withing a created virtual env
```ps
.\setvenv.ps1 -Script say_hello.ps1 -PythonVersion 3.8 -EnvDir .venv
```

options `-PythonVersion` and `-EnvDir` are optional an will defualt to `3` and `.venv` correspondingly
