Import-Module (Join-Path $PSScriptRoot "GitValidator.psm1") -Force

function gph {
    [CmdletBinding()]
    param (
        [string]$commitMessage,
        [switch]$f
    )

    if ([string]::IsNullOrEmpty($commitMessage)) {
        Write-Error "Commit message is required."
        return
    }

    ValidateGitDirectory

    # # Check if git is installed
    # if (-Not (Get-Command git -ErrorAction SilentlyContinue)) {
    #     Write-Error "Git is not installed. Please install Git before using this function."
    #     return
    # }

    Write-Host "Adding files to commit ..."
    git add .

    Write-Host "Commiting changes ..."
    git commit -m $commitMessage

    # Get the current branch name
    $branch = git rev-parse --abbrev-ref HEAD

    Write-Host "Pushing the commit to branch: $branch ..." 

    # Perform git push origin <current branch> (with force if -f switch is provided)
    if ($f) {
        Write-Host "FORCE Pushing ..."
        git push --force origin $branch
    } else {
        git push origin $branch
    }

    Write-Host "Add -> Commit -> Push to $branch successfully"
}

function gcb {
    [CmdletBinding()]
    param (
        # [Parameter(Mandatory=$true)]
        [string]$branchName,
        [string]$safeBranch = "master"
    )
    if ([string]::IsNullOrEmpty($branchName)) {
        Write-Error "New branch name to create is required"
        return
    }

    ValidateGitDirectory

    # # Check if git is installed
    # if (-Not (Get-Command git -ErrorAction SilentlyContinue)) {
    #     Write-Host "Git is not installed. Please install Git before using this function."
    #     return
    # }

    # # Check if the current directory is a git repository
    # if (-Not (Test-Path -PathType Container (Join-Path $_ ".git"))) {
    #     Write-Error "The current directory is not a git repository. Please run 'git init' first or change to a valid git repository directory."
    #     return
    # }
    

    # Get the current branch name
    Write-Host "Checking current branch ..."
    $currentBranch = git rev-parse --abbrev-ref HEAD

    # Check if the current branch is the one we want to delete
    if ($currentBranch -eq $branchName) {
        # Checkout the safe branch before deleting the target branch
        Write-Host "Check out to safe branch: $safeBranch"
        git checkout $SafeBranch
    }

    # Check if the branch exists locally
    $localBranches = git branch
    if ($localBranches -match "\b$branchName\b") {
        # The branch already exists locally, so force delete it
        git branch -D $branchName
        Write-Host "Delete out-date branch: $branchName"
    }

    # Create and checkout the new branch
    git checkout -b $branchName

    Write-Host "Create and check out a new branch successfully"
}
