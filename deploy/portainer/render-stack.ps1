param(
    [string]$EnvFile = "",
    [string]$FrappeDockerPath = "D:\dsf\frappe_docker",
    [string]$OutputFile = ""
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if ([string]::IsNullOrWhiteSpace($EnvFile)) {
    $EnvFile = Join-Path $scriptDir "stackerp.env"
}

if ([string]::IsNullOrWhiteSpace($OutputFile)) {
    $OutputFile = Join-Path $scriptDir "generated\stackerp.portainer.yaml"
}

$EnvFile = [System.IO.Path]::GetFullPath($EnvFile)
$OutputFile = [System.IO.Path]::GetFullPath($OutputFile)

if (-not (Test-Path $EnvFile)) {
    throw "Arquivo de ambiente nao encontrado: $EnvFile"
}

if (-not (Test-Path $FrappeDockerPath)) {
    throw "Caminho do frappe_docker nao encontrado: $FrappeDockerPath"
}

$outputDir = Split-Path -Parent $OutputFile
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

$composeArgs = @(
    "--env-file", $EnvFile,
    "-f", (Join-Path $FrappeDockerPath "compose.yaml"),
    "-f", (Join-Path $FrappeDockerPath "overrides\compose.mariadb.yaml"),
    "-f", (Join-Path $FrappeDockerPath "overrides\compose.redis.yaml"),
    "-f", (Join-Path $FrappeDockerPath "overrides\compose.noproxy.yaml"),
    "config"
)

Push-Location $FrappeDockerPath
try {
    docker compose @composeArgs | Set-Content -Path $OutputFile -Encoding utf8
    if ($LASTEXITCODE -ne 0) {
        throw "Falha ao renderizar a stack com docker compose."
    }
}
finally {
    Pop-Location
}

Write-Host "Stack renderizada em: $OutputFile"
