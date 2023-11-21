Import-Module CommonHelper
Import-Module GitHelper
Import-Module PSReadLine

Set-Alias -Name ls -Value runeza -Option AllScope
Set-Alias -Name cat -Value bat -Option AllScope

# PSReadLine Config
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource History
Set-PSReadlineOption -PredictionViewStyle ListView
Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# Start StarShip
Invoke-Expression (&starship init powershell)

##Set the color for Prediction (auto-suggestion)
# Set-PSReadlineOption -Colors @{"InlinePredictionColor" = "#123456" }
# Set-PSReadLineKeyHandler -Chord '"',"'" `
#                          -BriefDescription SmartInsertQuote `
#                          -LongDescription "Insert paired quotes if not already on a quote" `
#                          -ScriptBlock {
#     param($key, $arg)

#     $line = $null
#     $cursor = $null
#     [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

#     if ($line.Length -gt $cursor -and $line[$cursor] -eq $key.KeyChar) {
#         # Just move the cursor
#         [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
#     }
#     else {
#         # Insert matching quotes, move cursor to be in between the quotes
#         [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
#         [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
#         [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
#     }
# }