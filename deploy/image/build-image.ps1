param(
    [string]$ImageName = "stackerp",
    [string]$Tag = "layout-geral",
    [string]$RepoUrl = "https://github.com/GuilhermeGms3/stackerp.git",
    [string]$AppBranch = "Layout-geral",
    [string]$FrappeBranch = "version-16",
    [string]$FrappePath = "https://github.com/frappe/frappe",
    [string]$FrappeDockerPath = "D:\dsf\frappe_docker"
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$appsJsonPath = Join-Path $scriptDir "apps.json"
$containerfile = Join-Path $FrappeDockerPath "images\custom\Containerfile"

if (-not (Test-Path $FrappeDockerPath)) {
    throw "Caminho do frappe_docker nao encontrado: $FrappeDockerPath"
}

if (-not (Test-Path $containerfile)) {
    throw "Containerfile nao encontrado: $containerfile"
}

$appsJson = @"
[
  {
    "url": "$RepoUrl",
    "branch": "$AppBranch"
  }
]
"@

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($appsJsonPath, $appsJson, $utf8NoBom)

$fullTag = "${ImageName}:${Tag}"

Write-Host "Building $fullTag using $appsJsonPath"

docker build `
  --build-arg "FRAPPE_PATH=$FrappePath" `
  --build-arg "FRAPPE_BRANCH=$FrappeBranch" `
  --secret "id=apps_json,src=$appsJsonPath" `
  --tag $fullTag `
  --file $containerfile `
  $FrappeDockerPath

if ($LASTEXITCODE -ne 0) {
    throw "Falha no docker build. Verifique se o Docker Desktop/Engine esta em execucao."
}

Write-Host "Build concluido: $fullTag"
