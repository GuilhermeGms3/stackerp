# Next Steps

Ordem recomendada para continuar:

1. Confirmar o nome final da imagem
   - exemplo: `ghcr.io/guilhermegms3/stackerp`

2. Confirmar a branch que vai gerar imagem de deploy
   - exemplo inicial: `Layout-geral`
   - depois: `main` para producao

3. Testar build local da imagem
   - rodar `deploy/image/build-image.ps1`
   - validar se a imagem sobe localmente

4. Ajustar a stack do Portainer
   - copiar `stackerp.env.example` para `stackerp.env`
   - ajustar dominio, porta e senha do banco
   - renderizar `generated/stackerp.portainer.yaml`

5. Subir a stack no servidor
   - usar a imagem propria no Portainer
   - manter volumes persistentes para banco e sites

6. Automatizar
   - ativar workflow de GitHub Actions
   - publicar no GHCR
   - depois ligar webhook do Portainer

## Regra simples

- desenvolvimento local: bind mount
- servidor: imagem propria
