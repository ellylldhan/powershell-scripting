# gitpush version powershell
# 
# USAGE :
# -------
#    PS> gitpush.ps1 "mon message de commit"
#    PS> gitpush.ps1
#
# CONVERSION EN .EXE
# ------------------
#   PS> Install-Module ps2exe 
#   PS> Import-Module ps2exe 
#   PS> Invoke-ps2exe ./gitpush.ps1 ./gitpush.exe
#
#   # Appel 
#   PS> gitpush.exe 
#   PS> gitpush


$active_branch = (git rev-parse --abbrev-ref HEAD)
 if($null -eq $active_branch) {
    write-host "Ce n'est pas un repo git"
    exit
 }

#write-host "argv : " $args[0]
#write-host "argc : " $args.Length

if ($null -eq $args[0]) {
    $msg="update"
} else {
    $msg=$args[0]
}

write-host "=> " -nonewline 
write-host "$msg" -ForegroundColor Magenta 

git add -A ; git commit -m "$msg" ; git push origin $active_branch