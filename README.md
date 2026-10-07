# JF Baterias

Site estático da JF Baterias, com atendimento em Álvares Machado, Presidente Prudente e região.

## Conteúdo

- Página inicial com contato direto pelo WhatsApp
- Páginas locais para Álvares Machado e Presidente Prudente
- Páginas de serviços e marcas
- Metadados, dados estruturados, sitemap e robots.txt

Os arquivos prontos para hospedagem estão em `dist/`. A página inicial é `dist/index.html`.
A configuração em `vercel.json` indica à Vercel que a pasta publicada é `dist/`.

Para atualizar a home, edite `home.template.html` e `dist/style.css`. As demais páginas e os metadados são gerados por `build.ps1`. Depois execute:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\build.ps1
```

Os links de consulta abrem uma mensagem no WhatsApp; o site não armazena dados do visitante.
