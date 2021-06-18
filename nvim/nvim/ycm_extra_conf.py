def Settings( **kwargs ):
    import subprocess
    proc = subprocess.run(['which', 'python'], capture_output=True)
    python_path = proc.stdout.decode().strip()
    return {
        'interpreter_path': python_path,
    }
