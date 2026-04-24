# Construye y empaqueta cada proyecto Docker en imágenes tar
$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $root

$images = @(
    @{ Name = 'tienda-perritos-db'; Context = 'db'; Archive = 'db/tienda-perritos-db.tar' },
    @{ Name = 'tienda-perritos-backend'; Context = 'backend'; Archive = 'backend/tienda-perritos-backend.tar' },
    @{ Name = 'tienda-perritos-frontend'; Context = 'frontend'; Archive = 'frontend/tienda-perritos-frontend.tar' }
)

foreach ($image in $images) {
    Write-Host "Building image $($image.Name) from $($image.Context) ..." -ForegroundColor Cyan
    docker build --pull -t $($image.Name):latest "$($root)\$($image.Context)"

    Write-Host "Saving image $($image.Name) to $($image.Archive) ..." -ForegroundColor Cyan
    docker save -o "$($root)\$($image.Archive)" $($image.Name):latest
}

Write-Host 'Empaquetado completado. Imágenes exportadas en:' -ForegroundColor Green
foreach ($image in $images) {
    Write-Host " - $($image.Archive)"
}
