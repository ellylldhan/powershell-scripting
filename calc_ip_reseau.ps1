# ------------------------------------------------------------------------------------------------------------------   
# Fonction pour le calcul de l'Adresse reseau, adresse Broadcast, premier hote, dernier hote et nombre d'hotes total.

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
                $separator = '|'
                #$separator = ' | '
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
            #$separator = ' | '
            $separator = '|'

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
    $ip1 = convertIpBinToDec($ipBinString)
    $ip2 = convertIpBinToDec($ipReseauBin)
    $ip3 = convertIpBinToDec($ipFirstHost)
    $ip4 = convertIpBinToDec($ipLastHost)
    $ip5 = convertIpBinToDec($ipBroadcast)

    $maskStr = Calc_Mask($Masque)
    $maskBin = niceDisplayIpBin($maskStr)
    $maskIp  = convertIpBinToDec($maskBin)

    $ipDonneeNice = niceDisplayIpBin($ipBinString)
   

    write-host '-------------------------------------------------------------'
    write-host "IP Donnee       " $ipDonneeNice "@" $ip1 "/" $Masque
    #write-host "Masque donne    " $Masque
    Write-Host "IP Masque       " $maskBin "@" $maskIp
    Write-Host "IP Reseau       " $ipReseauBin "@" $ip2
    Write-Host "IP First Host   " $ipFirstHost "@" $ip3
    Write-Host "IP Last Host    " $ipLastHost  "@" $ip4
    Write-Host "IP Broadcast    " $ipBroadcast "@" $ip5
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

    # Initialisation de la liste retournee
    $listeIP = ''

    # Boucle sur chaque char de l'ip
    for ($i=0;$i -lt $ip.Length; $i++) {
        # Concatene chaque char de l'ip (on le reinit des qu'on a un octet)
        $a += $ip[$i]    

        # Si l'index est un multiple de 8, alors on a un octet (on ignore l'index 0)
        if (($i + 1 ) % 8 -eq 0 -and $i -ne 0) {
            # On ajoute l'octet à la liste finale
            $listeIP += [convert]::ToInt32("$a", 2)

            # On ajoute le point, sauf si on est en bout de chaîne de char
            if($i -ne ($ip.Length - 1)) { 
                $listeIP += '.' 
            }

            # Reinitialisation du string qui stocke chaque bit de l'ip
            $a = ''
        }
    }

    return $listeIP
}

function convertIpDecToBin($ipDec) {
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
    
    # Initialisation de la variable qui sera retournee
    $ipBin = ''

    # 'tite Bouclette sur chaque char de la string $ip
    for($i=0; $i -lt 32; $i++) 
    {
        # On commence par concatener le char de l'ip
        $ipBin += $ip[$i]

        # Separation des octets
        if (($i -eq 7 -or $i -eq 15 -or $i -eq 23) -and $i -ne 0) 
        {
            # Si index == masque, on separe par '|'. Sinon par un '.'
            if ($i -eq ($masque - 1)) 
            {
                #$ipBin += ' | '
                $ipBin += '|'
            } 
            else 
            {
                $ipBin += '.'
            }
        } 
        # Si c'est pas une separation d'octet mais la separation du masque
        elseif ($i -eq ($masque - 1)) 
        {
            # ... alors on ajoute un '|'
            #$ipBin += ' | '
            $ipBin += '|'
        } 
    }

    return $ipBin
}

# function niceDisplayIpDec($ip, $mask) {}

function convertIpBinToDec($ip) {
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


#############
## M A I N ##
#############

Write-host "Bienvenue dans l'outil de calcul d'adresse reseau !"

$choix = $null
while (($choix -ne 4) -or ($choix -ne 'q')) {
    write-host ""
    write-host "   1) Calcul d'adressage reseau d'apres IP et masque en decimal (ex. 192.168.1.1/24)"
    write-host "   2) Convertir une IP decimal en binaire (sans masque)"
    write-host "   3) Convertir une IP decimal en binaire (avec masque)"
    Write-host "   4) Quitter"
    write-host ""
    $choix = Read-host "Entrez votre choix"

    if ($choix -eq 1) {
        # Calcul d'adresses reseau
        #TODO: nettoyage du prompt de la fonction Calcul_Reseaux
        while (($ip -ne 'q') -or ($mask -ne 'q')) {
            Write-Host ""
            write-host "----------------------------"
            write-host "1. CALCUL D'ADRESSAGE RESEAU"
            write-host "----------------------------"
            write-host "(entrez 'q' pour quitter)"
            Write-Host ""
            $ip   = Read-Host "Entrez une adresse ip (ex. 10.52.1.0)"
            if($ip -eq 'q') {
                $choix = $null
                $ip = $null
                $mask = $null
                break
            }

            $mask = Read-Host "Entrez un masque au format CIDR (ex. 24)"
            if($mask -eq 'q') {
                $choix = $null
                $ip = $null
                $mask = $null
                break
            }

            Calcul_Reseaux $ip $mask
        }
    
    } elseif ($choix -eq 2) {
        # Convertir IP DECIMAL en BINAIRE
        while ($ip -ne 'q') {
            Write-Host ""
            write-host "----------------------------------------------"
            write-host "2. CONVERTISSEUR IP DEC > IP BIN (sans masque)"
            write-host "----------------------------------------------"
            write-host "(entrez 'q' pour quitter)"
            Write-Host ""
            $ip   = Read-Host "Entrez une adresse ip (ex. 10.52.1.0)"
            
            if($ip -eq 'q') {
                $choix = $null
                $ip = $null
                $mask = $null
                break
            }
     
            $ipBinFormatted = NiceDisplayIpBin(convertIpDecToBin $ip)

            write-host "==> " $ipBinFormatted
        }
    } elseif ($choix -eq 3) {
        # Convertir IP DECIMAL en BINAIRE avec separation du masque
        while (($ip -ne 'q') -or ($mask -ne 'q'))  {
            Write-Host ""
            write-host "----------------------------------------------"
            write-host "3. CONVERTISSEUR IP DEC > IP BIN (avec masque)"
            write-host "----------------------------------------------"
            write-host "(entrez 'q' pour quitter)"
            Write-Host ""
            $ip   = Read-Host "Entrez une adresse ip (ex. 10.52.1.0)"

            if($ip -eq 'q') {
                $choix = $null
                $ip = $null
                $mask = $null
                break
            }

           $mask = Read-Host "Entrez un masque au format CIDR (ex. 24)"

           if($mask -eq 'q') {
                $choix = $null
                $ip = $null
                $mask = $null
                break
           }
     
           $ipBin = convertIpDecToBin($ip)
           $ipNice =  niceDisplayIpBin $ipBin 
           $ipBinFormatted = niceDisplayIpBin $ipBin  $mask
            

            write-host "==> Prettyfied  : $ipNice"
            write-host "==> Avec masque : $ipBinFormatted"
        }
    
    } else {
        # Comportement par defaut
        write-host "Bye !"
        break
    }
}

