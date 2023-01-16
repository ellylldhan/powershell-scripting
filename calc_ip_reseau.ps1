# ------------------------------------------------------------------------------------------------------------------   
# Fonction pour le calcul de l'Adresse réseau, adresse Broadcast, premier hote, dernier hote et nombre d'hotes total.
 
function Calcul_Reseaux($AdresseIP, $Masque) {
    # Input  : 192.168.0.12
    # Output : "192", "168", "0", "12"
    $ipDecListe = $AdresseIP.Split('.')

    $ipBinString = ''
    foreach($ip in $ipDecListe) {
        $ipBinString += ([convert]::ToString($ip,2)).PadLeft(8, '0')
        # $ipBinStringSplit  += ([convert]::ToString($ip,2)).PadLeft(8, '0')
        # $ipBinStringSplit +=  '.'
    }
   
    $ipDonneeSplit=''
    $ipReseauBin = ''
    $ipFirstHost = ''
    $ipLastHost  = ''
    $ipBroadcast = ''
    
    for($j=0;$j -lt $ipBinString.Length; $j++) {
        if ($j -lt $Masque) {
            $ipDonneeSplit+=$ipBinString[$j]
            $ipReseauBin += $ipBinString[$j]
            $ipFirstHost += $ipBinString[$j]
            $ipLastHost  += $ipBinString[$j]
            $ipBroadcast += $ipBinString[$j]
        } else {
            $ipDonneeSplit+=$ipBinString[$j]
            $ipReseauBin += '0'
            $ipBroadcast += '1'

            if ($j -eq ($ipBinString.Length - 1)) {
                $ipFirstHost += '1'
                $ipLastHost  += '0'
            } else {
                $ipFirstHost += '0'
                $ipLastHost  += '1'
            }
        }

        $separated = $false
        if (($j -eq 7 -or $j -eq 15 -or $j -eq 23) -and $j -ne 0) {
            if ($j -eq ($Masque - 1)) {
                $separator = ' | '
            } else {
                $separator = '.'
            }

            $ipDonneeSplit+=$separator
            $ipReseauBin += $separator
            $ipFirstHost += $separator
            $ipLastHost  += $separator
            $ipBroadcast += $separator

            $separated = $true
        } elseif ($j -eq ($Masque - 1) -and $separated -eq $false) {
            $separator = ' | '

            $ipDonneeSplit+=$separator
            $ipReseauBin += $separator
            $ipFirstHost += $separator
            $ipLastHost  += $separator
            $ipBroadcast += $separator

            $separated = $true
        }

        $separated = $null
    }

    # Convertion en DECIMAL
    $ip1 = convertIPToDec($ipBinString)
    $ip2 = convertIPToDec($ipReseauBin)
    $ip3 = convertIPToDec($ipFirstHost)
    $ip4 = convertIPToDec($ipLastHost)
    $ip5 = convertIPToDec($ipBroadcast)

    $mask_bin = Calc_Mask($mask)
    $mask_ip  = convertIPToDec($mask_bin)

    write-host '-------------------------------------------------------------'
    write-host "DEBUG - IP Donnée       " $ipBinString $ip1
    write-host "DEBUG - Masque donné    " $Masque
    Write-Host "DEBUG - IP Masque       " $mask_bin $mask_ip
    Write-Host "DEBUG - IP Réseau       " $ipReseauBin $ip2
    Write-Host "DEBUG - IP First Host   " $ipFirstHost $ip3
    Write-Host "DEBUG - IP Last Host    " $ipLastHost  $ip4
    Write-Host "DEBUG - IP Broadcast    " $ipBroadcast $ip5
    write-host '-------------------------------------------------------------'
    
    # TODO: function convertIPToBin: string
    # TODO: function splitIPBin: string

}


function convertBinToDec($ip) {
    # IN  : 00111000.01110000.0011 | 0011.01111000
    # OUT : 192.168.12.34

    # Nettoyage
    $ip = $ip.Replace('.', '')
    $ip = $ip.Replace('|', '')
    $ip = $ip.Replace(' ', '')

    # Initialisation de la liste retournée
    $listeIP = ''

    # Boucle sur chaque char de l'ip
    for ($i=0;$i -lt $ip.Length; $i++) {
        # Concatene chaque char de l'ip (on le reinit dès qu'on a un octet)
        $a += $ip[$i]    

        # Si l'index est un multiple de 8, alors on a un octet (on ignore l'index 0)
        if (($i + 1 ) % 8 -eq 0 -and $i -ne 0) {
            # On ajoute l'octet à la liste finale
            $listeIP += [convert]::ToInt32("$a", 2)

            # On ajoute le point, sauf si on est en bout de chaîne de char
            if($i -ne ($ip.Length - 1)) { 
                $listeIP += '.' 
            }

            # Réinitialisation du string qui stocke chaque bit de l'ip
            $a = ''
        }
    }

    return $listeIP
}

function convertDecToBin($ipDec) {
    # IN  : 192.168.0.12
    # OUT : 01010000101000100110010100111100
    $ipDecListe = $ipDec.Split('.')

    $ipBinString = ''
    foreach($ip in $ipDecListe) {
        $ipBinString += ([convert]::ToString($ip,2)).PadLeft(8, '0')
    }
    return $ipBinString
}

function niceDisplayIpBin($ip, $masque) {
    # IN  : '01010000101000100110010100111100' 19
    # OUT : 01010000.10100010.011 | 00101.00111100
    
    # Initialisation de la variable qui sera retournée
    $ipBin = ''

    # 'tite Bouclette sur chaque char de la string $ip
    for($i=0; $i -lt 32; $i++) 
    {
        # On commence par concaténer le char de l'ip
        $ipBin += $ip[$i]

        # Séparation des octets
        if (($i -eq 7 -or $i -eq 15 -or $i -eq 23) -and $i -ne 0) 
        {
            # Si index == masque, on sépare par '|'. Sinon par un '.'
            if ($i -eq ($masque - 1)) 
            {
                $ipBin += ' | '
            } 
            else 
            {
                $ipBin += '.'
            }
        } 
        # Si c'est pas une séparation d'octet mais la séparation du masque
        elseif ($i -eq ($masque - 1)) 
        {
            # ... alors on ajoute un '|'
            $ipBin += ' | '
        } 
    }

    return $ipBin
}

# function niceDisplayIpDec($ip, $mask) {}

function convertIPToDec($ip) {
    $ip = $ip.Replace('.', '')
    $ip = $ip.Replace('|', '')
    $ip = $ip.Replace(' ', '')

    # write-host "DEBUG - ip" $ip

    $listeIP = ''

    for ($i=0;$i -lt $ip.Length; $i++) {
        $a += $ip[$i]    
        if (($i + 1 ) % 8 -eq 0 -and $i -ne 0) {
            $listeIP += [convert]::ToInt32("$a", 2)
            if($i -ne ($ip.Length - 1)) { 
                $listeIP += '.' 
            }
            $a = ''
        }
    }

    return $listeIP
}


function Calc_Mask($mask) {
    $str=''

    for ($i=0; $i -lt 32; $i++) {
        if ($i -lt $mask) {
            $str += '1'
        } else {
            $str += '0'
        }
    }

    return $str
}


$ip = '192.168.128.0'
$mask = 17


write-host "ex. $ip / $mask"



Calcul_Reseaux $ip $mask

