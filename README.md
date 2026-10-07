# JF Baterias

Site estático da JF Baterias, com atendimento em Álvares Machado, Presidente Prudente e região.

## Conteúdo

- Página inicial com contato direto pelo WhatsApp
- Páginas locais para Álvares Machado e Presidente Prudente
- Páginas de serviços e marcas
- Metadados, dados estruturados, sitemap e robots.txt

Os arquivos prontos para hospedagem estão em `dist/`. A página inicial é `dist/index.html`.
A configuração em `vercel.json` indica à Vercel que a pasta publicada é `dist/`.

Para atualizar as páginas geradas, edite `build.ps1` e execute:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\build.ps1
```

O formulário apenas prepara uma mensagem no WhatsApp; não armazena os dados no site.
