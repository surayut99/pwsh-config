
function ValidateGitDirectory {
    # Check if git is installed
    if (-Not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error "Git is not installed. Please install Git before using this function."
        return
    }

    # Check if the current directory is a git repository
    if (-Not (Test-Path -PathType Container (Join-Path $PWD ".git"))) {
        Write-Error "The current directory is not a git repository. Please run 'git init' first or change to a valid git repository directory."
        return
    }
}