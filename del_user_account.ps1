# Récupérer tous les profils utilisateurs
$userProfiles = Get-CimInstance -Class Win32_UserProfile | Where-Object { 
    $_.Special -eq $false -and $_.LocalPath -notmatch "Default|Public"
}

# Vérifier s'il y a des utilisateurs à afficher
if ($userProfiles.Count -eq 0) {
    Write-Host "Aucun profil utilisateur disponible pour suppression." -ForegroundColor Yellow
    exit
}

# Afficher la liste des profils utilisateurs
Write-Host "Liste des utilisateurs détectés :"
$userProfiles | ForEach-Object {
    $index = $userProfiles.IndexOf($_) + 1
    Write-Host "$index. $($_.LocalPath.Split('\')[-1])"
}

# Demander à l'utilisateur de sélectionner un numéro
$selection = Read-Host "Entrez le numéro du profil utilisateur à supprimer (ou 'q' pour quitter)"

# Quitter si l'utilisateur entre 'q'
if ($selection -eq 'q') {
    Write-Host "Opération annulée." -ForegroundColor Green
    exit
}

# Vérifier si l'entrée est un numéro valide
if (-not ($selection -as [int]) -or ($selection -lt 1) -or ($selection -gt $userProfiles.Count)) {
    Write-Host "Numéro invalide. Veuillez relancer le script." -ForegroundColor Red
    exit
}

# Récupérer le profil utilisateur sélectionné
$selectedProfile = $userProfiles[$selection - 1]
$userName = $selectedProfile.LocalPath.Split('\')[-1]
Write-Host "Vous avez sélectionné : $userName" -ForegroundColor Cyan

# Demander confirmation
$confirmation = Read-Host "Confirmez-vous la suppression de $userName ? (o/n)"
if ($confirmation -ne 'o') {
    Write-Host "Suppression annulée." -ForegroundColor Green
    exit
}

# Tenter de supprimer le profil
try {
    $selectedProfile | Remove-CimInstance
    Write-Host "Le profil utilisateur $userName a été supprimé avec succès." -ForegroundColor Green
} catch {
    Write-Host "Erreur lors de la suppression de $userName : $($_.Exception.Message)" -ForegroundColor Red
}
