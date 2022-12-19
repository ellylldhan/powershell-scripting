# powershell-scripting
Powershell Sysadmin Utilities


More on https://gitlab.com/ellylldhan 


D'après @FredPowers Powershell.  :)

[TOC]

### calc_ip.ps1
Convertisseur DECIMAL <=> BINAIRE pour IP, avec marquage du masque

**Usage** : 

- Pour l'instant, modifier à la dure les variables dans le script 
- TODO: prendre les arguments en input, en CLI et/ou avec `read-host`.

```
Output :
--------

DEC to BIN                  192.168.35.12 / 17 => 11000000101010000010001100001100
BIN to DEC    01010000101000100110010100111100 => 80.162.101.60
Nice Display                     192.168.35.12 => 11000000.10101000.0 | 0100011.00001100
Nice Display  01010000101000100110010100111100 => 01010000.10100010.0 | 1100101.00111100
```



### gitpush.ps1
Version Powershell d'un script Bash permettant de push facilement sur un repo git.

Equivaut à un `git add -A && git commit -m $MON_MESSAGE && git push origin $MA_BRANCHE`, où le message peut être donné en argument du script.

**Usage** : 

```ps1
PS> gitpush.ps1 "mon message de commit"
PS> gitpush.ps1                                 
``` 


#### Note : Conversion d'un .ps1 en .exe

```ps1
PS> Install-Module ps2exe 
PS> Import-Module ps2exe 
PS> Invoke-ps2exe ./gitpush.ps1 ./gitpush.exe
```
```ps1
# Appel 
PS> gitpush.exe 
PS> gitpush
```

- alias **ps2exe** fonctionne aussi
- dans la mesure où le .exe est placé dans un dossier connu du **PATH**
