# Permet d'avoir une liste des ordinateurs du domaine (sauf "*SRV*")
# ainsi que les noms de leurs 5 dernières sessions.
# 
# Par extension, permet d'avoir le nom de l'utilisateur courant là où quser échoue parfois.
# 
# Version : 1.0
# Date    : 2022-12-06
# Author  : ellylldhan


import-module ActiveDirectory

#$computers = Get-Content computers.txt
$computers = (get-adcomputer -filter * -properties name |  Where-Object -FilterScript { $_.enabled -like $true -and $_.name -notlike '*SRV*' } | Sort-Object name | Format-Table -Property name)

foreach ($computer in $computers) { 
   
    $output = (Get-ChildItem "\\$computer\c$\users" 2>$null)
    if ($null -ne $output) { 
        $output = (Get-ChildItem "\\$computer\c$\users" | Sort-Object LastWriteTime -Descending | Select-Object Name, LastWriteTime -first 5 | Format-Table -Property $computer, Name, LastWriteTime )
        $output >> "logons.csv"
    }
    else { 
        pass
    }   
}
