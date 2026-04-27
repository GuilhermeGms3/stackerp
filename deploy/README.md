# StackErp Deploy

Este diretorio concentra a base de build e deploy do `StackErp`.

Objetivo:

- desenvolver localmente com bind mount em `D:\dsf\stackerp`
- gerar imagem propria para Portainer/producao
- manter o `erpnext` como nome tecnico interno do app por enquanto

## Estrutura

- `image/apps.json`: apps incluidos no build da imagem
- `image/build-image.ps1`: build local da imagem `StackErp`
- `portainer/stackerp.env.example`: variaveis base para a stack
- `portainer/render-stack.ps1`: gera um compose final para uso no Portainer

## Pre-requisitos

- Docker Engine 23+
- Docker Compose v2
- `D:\dsf\frappe_docker` clonado localmente

## Build local da imagem

Exemplo:

```powershell
.\deploy\image\build-image.ps1 `
  -ImageName stackerp `
  -Tag layout-geral `
  -RepoUrl https://github.com/GuilhermeGms3/stackerp.git `
  -AppBranch Layout-geral
```

Esse script usa o `images/custom/Containerfile` do `frappe_docker` e injeta o `apps.json` como secret de build.

## Render da stack para Portainer

1. Copie `deploy/portainer/stackerp.env.example` para um arquivo real, por exemplo `stackerp.env`
2. Ajuste imagem, tag, senha do banco, dominio e demais variaveis
3. Rode:

```powershell
.\deploy\portainer\render-stack.ps1 -EnvFile .\deploy\portainer\stackerp.env
```

O script gera um YAML final consolidado em `deploy/portainer/generated/stackerp.portainer.yaml`.

## Fluxo recomendado

### Desenvolvimento local

- editar `D:\dsf\stackerp`
- rebuildar assets no container
- testar localmente

### Deploy

- commit/push
- build da imagem `StackErp`
- push para GHCR ou Docker Hub
- Portainer faz redeploy usando a nova tag

## Observacoes

- este fluxo ainda considera o app como `erpnext` internamente
- o nome comercial/produto pode ser `StackErp`
- a imagem final deve ser usada no servidor; bind mount fica so para desenvolvimento
