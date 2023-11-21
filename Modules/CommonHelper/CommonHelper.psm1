function runexa { wsl -e bash -c "exa $args" }

function wslrc { wsl -e bash -c $args }

function runeza {
    $argsAsString = $args -join ' '

    if ($argsAsString -match '\~') {
        $argsAsString = $argsAsString -replace '\~', $HOME
    }

    if ($argsAsString -match '\\') {
        $argsAsString = $argsAsString -replace '\\', '/'
    }

    eza -laoF --icons=always --color-scale-mode=fixed --group-directories-first $argsAsString   
}

function reloadps { . $PROFILE }

function hp {
    param (
        [string]$command
    )

    $desc = $null


    $desc = Invoke-Expression "$command --help" -ErrorAction SilentlyContinue 2>$null
    if ($desc) {
        $desc | less
        return
    }

    $desc = Invoke-Expression "$command -h" -ErrorAction SilentlyContinue 2>$null
    if ($desc) {
        $desc | less
        return
    }

    $desc = Get-Help $command -ErrorAction SilentlyContinue
    if ($desc) {
        $desc | less
        return
    }

    Write-Error "Not found command description for: $command"

}
