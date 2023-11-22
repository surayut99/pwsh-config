Import-Module (Join-Path $PSScriptRoot "GitValidator.psm1") -Force

function gstat {
    git status
}

function glog {
    param (
        [switch]$b
    )

    if ($b) {
        git log --all --decorate --oneline --graph
    } else {
        git log
    }
    
}

function greset {
    param (
        [int] $count,
        [switch] $h
    )

    if ($h) {
        git reset --hard HEAD~$count
    }
    else {
        git reset --soft HEAD~$count
    }
    
}


function gcommit {
    [CmdletBinding()]
    param (
        [string]$commitMessage,
        [switch]$a
    )

    if ([string]::IsNullOrEmpty($commitMessage)) {
        Write-Error "Commit message is required."
        return
    }

    ValidateGitDirectory

    Write-Host "Adding files to commit..."
    git add .

    Write-Host "Commiting changes..."
    git commit -m $commitMessage

    # Perform git push origin <current branch> (with force if -f switch is provided)
    if ($a) {
        Write-Host "Amending previous commit message..."
        git commit --amend -m $commitMessage
    }
    else {
        git commit -m $commitMessage
    }

    Write-Host "Add -> Commit successfully"
}

function gpush {
    [CmdletBinding()]
    param (
        [string]$commitMessage,
        [string]$origin = "origin",
        [switch]$f
    )

    if ([string]::IsNullOrEmpty($commitMessage)) {
        Write-Error "Commit message is required."
        return
    }

    ValidateGitDirectory

    # Get the current branch name
    $branch = git rev-parse --abbrev-ref HEAD

    Write-Host "Adding files to commit ..."
    git add .

    Write-Host "Commiting changes ..."
    git commit -m $commitMessage

    Write-Host "Pushing the commit to branch: $branch ..." 

    # Perform git push origin <current branch> (with force if -f switch is provided)
    if ($f) {
        Write-Host "FORCE Pushing ..."
        git push --force $origin $branch
    }
    else {
        git push $origin $branch
    }

    Write-Host "Add -> Commit -> Push to $branch successfully"
}

function gco {
    [CmdletBinding()]
    param (
        [string]$branchName,
        [switch]$r,
        [string]$safeBranch = "master"
    )
    if ([string]::IsNullOrEmpty($branchName)) {
        Write-Error "New branch name to create is required"
        return
    }

    ValidateGitDirectory

    # Get the current branch name
    Write-Host "Checking current branch ..."
    $currentBranch = git rev-parse --abbrev-ref HEAD

    # Re-create branch
    if ($r) {
        # Check if the current branch is the one we want to delete
        if ($currentBranch -eq $branchName) {
            # Checkout the safe branch before deleting the target branch
            Write-Host "Check out to safe branch: $safeBranch"
            git checkout $SafeBranch
            git branch -D $branchName
            git checkout -b $branchName
            Write-Host "Re-create branch: $safeBranch successfully"
            return;
        }
    }

    git checkout $branchName 2>null | Invoke-Expression
    $currentBranch = git rev-parse --abbrev-ref HEAD

    if (!($currentBranch -eq $branchName)) {
        git checkout -b $branchName
    }

}
