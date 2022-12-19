# powershell-scripting
Powershell Sysadmin Utilities


More on https://gitlab.com/ellylldhan 


D'après [@FredPowers](https://github.com/FredPowers) Powershell.  :)

[TOC]

### calc_ip.ps1
Convertisseur DECIMAL <=> BINAIRE pour IP, avec marquage du masque

**Usage** : 

```
PS> calc_ip_reseau.ps1       # les arguments sont codés en dur dans le code source
```

**Output** :

```
DEC to BIN                  192.168.35.12 / 17 => 11000000101010000010001100001100
BIN to DEC    01010000101000100110010100111100 => 80.162.101.60
Nice Display                     192.168.35.12 => 11000000.10101000.0 | 0100011.00001100
Nice Display  01010000101000100110010100111100 => 01010000.10100010.0 | 1100101.00111100
```

**TODO**:

- Prendre les arguments en CLI ou avec un READ-HOST.

### calc_ip_reseau.ps1
Calculateur d'adresses réseau d'après une IP et un masque.

**Usage** 

```
PS> calc_ip_reseau.ps1
```

**Output**: 

```
ex. 10.14.23.15 / 14
-------------------------------------------------------------
DEBUG - IP Donnée        00001010000011100001011100001111         10.14.23.15
DEBUG - Masque donné     14
DEBUG - IP Réseau        00001010.000011 | 00.00000000.00000000   10.12.0.0
DEBUG - IP First Host    00001010.000011 | 00.00000000.00000001   10.12.0.1
DEBUG - IP Last Host     00001010.000011 | 11.11111111.11111110   10.15.255.254
DEBUG - IP Broadcast     00001010.000011 | 11.11111111.11111111   10.15.255.255
-------------------------------------------------------------
```

**TODO**:

- Prendre les arguments en CLI ou avec un READ-HOST.
- Tout calculer en binaire plutôt que parcourir la chaîne de caractères ?


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
