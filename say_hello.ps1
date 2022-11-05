py -0
$Hello = $(py -c "import sys; print(f'Hello from Python:  {sys.version}')")
py -c "import sys; print(f'{sys.executable}')"
return $Hello