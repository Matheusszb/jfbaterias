$ErrorActionPreference = 'Stop'
$Origin = 'https://jfbaterias.vercel.app'
$Root = Join-Path $PSScriptRoot 'dist'
$Wa = 'https://wa.me/5518991114834?text=Ol%C3%A1%21%20Vim%20pelo%20site%20da%20JF%20Baterias.%20Preciso%20de%20uma%20bateria%20para%20meu%20ve%C3%ADculo.%20Poderia%20me%20informar%20o%20valor%20e%20o%20prazo%20para%20entrega%20e%20instala%C3%A7%C3%A3o%3F'
$BizSchema = @{
  '@context' = 'https://schema.org'
  '@type' = 'AutomotiveBusiness'
  '@id' = "$Origin/#business"
  name = 'JF Baterias'
  url = $Origin
  telephone = '+5518991114834'
  description = 'Venda, entrega, teste e instalação de baterias automotivas em Álvares Machado, Presidente Prudente e região.'
  areaServed = @(
    @{ '@type' = 'City'; name = 'Álvares Machado'; address = @{ '@type' = 'PostalAddress'; addressRegion = 'SP'; addressCountry = 'BR' } },
    @{ '@type' = 'City'; name = 'Presidente Prudente'; address = @{ '@type' = 'PostalAddress'; addressRegion = 'SP'; addressCountry = 'BR' } }
  )
}
function Write-Page {
  param([string]$Path,[string]$Title,[string]$Description,[string]$Body,[string]$Type='WebPage',[array]$Faq=@())
  $slug = if ($Path -eq '') { '' } else { "/$Path" }
  $canonical = if ($Path -eq '') { "$Origin/" } else { "$Origin$slug" }
  $schema = @($BizSchema, @{
    '@context'='https://schema.org'; '@type'=$Type; name=$Title; description=$Description; url=$canonical;
    isPartOf=@{ '@type'='WebSite'; name='JF Baterias'; url=$Origin }
  })
  if ($Type -eq 'Service') {
    $schema[1].provider = @{ '@id' = "$Origin/#business" }
    $schema[1].areaServed = @('Álvares Machado','Presidente Prudente')
  }
  if ($Path -ne '') {
    $schema += @{ '@context'='https://schema.org'; '@type'='BreadcrumbList'; itemListElement=@(
      @{ '@type'='ListItem'; position=1; name='Início'; item=$Origin },
      @{ '@type'='ListItem'; position=2; name=$Title; item=$canonical }
    ) }
  }
  if ($Faq.Count -gt 0) {
    $entities = @()
    foreach ($item in $Faq) { $entities += @{ '@type'='Question'; name=$item.Q; acceptedAnswer=@{ '@type'='Answer'; text=$item.A } } }
    $schema += @{ '@context'='https://schema.org'; '@type'='FAQPage'; mainEntity=$entities }
  }
  $json = $schema | ConvertTo-Json -Depth 12 -Compress
  $json = $json.Replace('<','\u003c')
  $safeTitle = [System.Net.WebUtility]::HtmlEncode($Title)
  $safeDescription = [System.Net.WebUtility]::HtmlEncode($Description)
  $html = @"
<!doctype html>
<html lang="pt-BR">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>$safeTitle</title>
  <meta name="description" content="$safeDescription">
  $(if ($Path -eq '404') { '<meta name="robots" content="noindex">' })
  <meta name="theme-color" content="#08090a">
  <link rel="canonical" href="$canonical">
  <link rel="icon" type="image/svg+xml" href="/favicon.svg">
  <meta property="og:type" content="website">
  <meta property="og:locale" content="pt_BR">
  <meta property="og:site_name" content="JF Baterias">
  <meta property="og:title" content="$safeTitle">
  <meta property="og:description" content="$safeDescription">
  <meta property="og:url" content="$canonical">
  <meta name="twitter:card" content="summary">
  <link rel="stylesheet" href="/style.css?v=brand-fit-2">
  <script type="application/ld+json">$json</script>
  <script defer src="/site.js"></script>
</head>
<body>
<a class="skip" href="#conteudo">Pular para o conteúdo</a>
<header class="site-header"><div class="wrap header-inner">
  <a class="brand" href="/" aria-label="JF Baterias — início"><img src="/assets/jf-baterias-logo.png" width="106" height="65" alt="JF Baterias"></a>
  <button class="menu-toggle" type="button" aria-label="Abrir menu" aria-expanded="false" aria-controls="menu">☰ Menu</button>
  <nav class="nav" id="menu" aria-label="Menu principal">
    <a href="/#veiculos">Veículos</a><a href="/#marcas">Marcas</a><a href="/#como-funciona">Como funciona</a><a href="/#areas">Região</a><a class="button small" href="$Wa" target="_blank" rel="noopener">Pedir bateria</a>
  </nav>
</div></header>
<div class="service-strip">Entrega e instalação gratuitas em horário comercial</div>
<main id="conteudo">$Body</main>
<footer class="site-footer"><div class="wrap">
  <div class="footer-grid">
    <div><img src="/assets/jf-baterias-logo.png" width="130" height="130" alt="JF Baterias"><p>Baterias com entrega e instalação gratuitas em horário comercial em Álvares Machado, Presidente Prudente e região.</p><a href="tel:+5518991114834">(18) 99111-4834</a></div>
    <div><h3>Atendimento</h3><a href="/bateria-delivery-alvares-machado">Álvares Machado</a><a href="/bateria-delivery-presidente-prudente">Presidente Prudente</a><a href="/instalacao-de-bateria">Instalação de bateria</a><a href="/teste-de-bateria-e-alternador">Teste de bateria e alternador</a></div>
    <div><h3>Baterias</h3><a href="/bateria-moura">Moura</a><a href="/bateria-heliar">Heliar</a><a href="/bateria-eletran">Eletran</a><a href="/politica-de-privacidade">Política de Privacidade</a></div>
  </div>
  <div class="copyright">JF Baterias © 2026. Todos os direitos reservados.</div>
</div></footer>
<a class="float-whatsapp" href="$Wa" target="_blank" rel="noopener" aria-label="Pedir bateria pelo WhatsApp">✆</a>
<div class="mobile-cta"><a class="button" href="$Wa" target="_blank" rel="noopener">Pedir bateria pelo WhatsApp</a></div>
</body></html>
"@
  $dir = if ($Path -eq '') { $Root } else { Join-Path $Root $Path }
  New-Item -ItemType Directory -Force $dir | Out-Null
  [System.IO.File]::WriteAllText((Join-Path $dir 'index.html'),$html,(New-Object System.Text.UTF8Encoding($false)))
}
$homeFaq = @(
  @{Q='Vocês instalam no local?';A='Sim. A entrega e a instalação são gratuitas em horário comercial, no endereço combinado e na região atendida. Consulte a disponibilidade pelo WhatsApp.'},
  @{Q='Como sei qual bateria comprar?';A='Envie modelo, ano e motor do veículo. Verificamos a opção adequada.'},
  @{Q='Vocês atendem meu bairro?';A='Atendemos Álvares Machado e regiões de Presidente Prudente. Envie sua localização para confirmar.'}
)
$homeBody = [System.IO.File]::ReadAllText((Join-Path $PSScriptRoot 'home.template.html'), [System.Text.Encoding]::UTF8)
$homeMessages = @{
  'WA_MOTO'='Olá! Vim pelo site da JF Baterias e preciso de uma bateria para minha moto.'
  'WA_CARRO'='Olá! Vim pelo site da JF Baterias e preciso de uma bateria para meu carro.'
  'WA_PESADO'='Olá! Vim pelo site da JF Baterias e preciso de uma bateria para veículo pesado.'
  'WA_MOURA'='Olá! Gostaria de consultar uma bateria Moura para meu veículo.'
  'WA_HELIAR'='Olá! Gostaria de consultar uma bateria Heliar para meu veículo.'
  'WA_ELETRAN'='Olá! Gostaria de consultar uma bateria Eletran para meu veículo.'
}
foreach ($key in $homeMessages.Keys) {
  $homeBody = $homeBody.Replace($key,('https://wa.me/5518991114834?text=' + [uri]::EscapeDataString($homeMessages[$key])))
}
$homeBody = $homeBody.Replace('WA_LINK',$Wa)
Write-Page -Path '' -Title 'JF Baterias | Bateria Delivery em Álvares Machado e Presidente Prudente' -Description 'Bateria arriou? A JF Baterias entrega e instala em Álvares Machado, Presidente Prudente e região. Teste de bateria e alternador. Chame no WhatsApp.' -Body $homeBody -Faq $homeFaq
$machadoFaq = @(
  @{Q='A bateria pode ser instalada em casa em Álvares Machado?';A='Sim. Combinamos a entrega e a instalação no endereço informado, conforme disponibilidade.'},
  @{Q='Preciso saber a amperagem antes de chamar?';A='Não. Envie modelo, ano e motor do veículo para verificarmos a bateria compatível.'}
)
$machado = @'
<section class="page-hero"><div class="wrap"><div class="breadcrumb"><a href="/">Início</a> / Álvares Machado</div><div class="eyebrow">Atendimento local</div><h1>Bateria delivery em <span>Álvares Machado</span></h1><p>O carro não pegou? A JF Baterias leva a bateria adequada até você, faz a instalação no local e verifica o funcionamento do sistema.</p><a class="button" href="WA_LINK" target="_blank" rel="noopener">Pedir bateria em Álvares Machado</a></div></section>
<section class="section"><div class="wrap detail-grid"><div><h2>Troca de bateria sem sair com o carro</h2><p>Quando a bateria arriou, o primeiro passo é entender se ela precisa mesmo ser substituída. No atendimento, verificamos a condição da bateria e o sistema de carga. Se a troca for necessária, apresentamos a opção compatível com o veículo e instalamos no endereço combinado em Álvares Machado.</p><p>Trabalhamos com baterias para carros, motos e veículos pesados, incluindo Moura, Heliar e Eletran, conforme disponibilidade. Para receber uma indicação, envie modelo, ano e motorização. Assim podemos consultar a amperagem e a tecnologia corretas antes da visita.</p><div class="note">O prazo de entrega depende da localização e da disponibilidade da bateria. Consulte pelo WhatsApp.</div></div><aside class="aside-box"><h3>O que informar</h3><ul><li>Modelo e ano do veículo</li><li>Motorização, se souber</li><li>Bairro ou localização</li><li>Se o carro apresenta dificuldade na partida</li></ul><a class="button" href="WA_LINK" target="_blank" rel="noopener">Consultar atendimento</a></aside></div></section>
<section class="section alt"><div class="wrap image-text"><img src="/assets/bateria-instalada.jpg" width="1600" height="900" loading="lazy" alt="Bateria instalada pela JF Baterias em veículo automotivo"><div><div class="eyebrow">Em Álvares Machado</div><h2 class="section-title">Entrega, instalação <span>e teste.</span></h2><p class="copy">Levamos a bateria ao local combinado, instalamos e conferimos a partida. Também verificamos o sistema de carga para ajudar a identificar problemas no alternador.</p><p class="copy">Se estiver em uma área próxima de Álvares Machado, envie sua localização para confirmar o atendimento.</p><a class="text-link" href="/teste-de-bateria-e-alternador">Como funciona o teste</a></div></div></section>
<section class="section"><div class="wrap"><div class="section-head"><h2 class="section-title">Dúvidas sobre o <span>atendimento local</span></h2></div><div class="faq"><details><summary>A bateria pode ser instalada em casa em Álvares Machado?</summary><p>Sim. Combinamos a entrega e a instalação no endereço informado, conforme disponibilidade.</p></details><details><summary>Preciso saber a amperagem antes de chamar?</summary><p>Não. Envie modelo, ano e motor do veículo para verificarmos a bateria compatível.</p></details></div></div></section>
<section class="cta-band"><div class="wrap cta-grid"><div><h2>Ficou sem partida?</h2><p>Informe seu veículo e sua localização em Álvares Machado.</p></div><a class="button" href="WA_LINK" target="_blank" rel="noopener">Chamar a JF Baterias</a></div></section>
'@
Write-Page -Path 'bateria-delivery-alvares-machado' -Title 'Bateria Delivery em Álvares Machado | JF Baterias' -Description 'Bateria delivery em Álvares Machado com entrega, instalação e teste no local. Consulte Moura, Heliar e Eletran pelo WhatsApp da JF Baterias.' -Body $machado.Replace('WA_LINK',$Wa) -Type 'Service' -Faq $machadoFaq
$prudenteFaq = @(
  @{Q='A JF Baterias atende meu bairro em Presidente Prudente?';A='Atendemos diversos bairros de Presidente Prudente. Envie sua localização pelo WhatsApp para confirmar a disponibilidade.'},
  @{Q='Vocês fazem teste antes da troca?';A='Sim. Verificamos a bateria e o sistema de carga para orientar a substituição quando necessária.'}
)
$prudente = @'
<section class="page-hero"><div class="wrap"><div class="breadcrumb"><a href="/">Início</a> / Presidente Prudente</div><div class="eyebrow">Atendimento local</div><h1>Bateria delivery em <span>Presidente Prudente</span></h1><p>Precisou de bateria e o veículo não liga? Consulte entrega, teste e instalação no local em diversos bairros de Presidente Prudente.</p><a class="button" href="WA_LINK" target="_blank" rel="noopener">Pedir bateria em Presidente Prudente</a></div></section>
<section class="section"><div class="wrap detail-grid"><div><h2>Atendimento no seu bairro</h2><p>A JF Baterias atende motoristas em diferentes regiões de Presidente Prudente. Você envia o modelo do veículo e o bairro; nós verificamos a bateria adequada, a disponibilidade e o prazo de entrega para o seu endereço. Na visita, podemos testar a bateria e o sistema de carga antes da substituição.</p><p>O serviço é útil quando o carro não dá partida em casa, no trabalho ou em outro local combinado. A instalação é feita ali mesmo, com conferência do funcionamento após a troca.</p><h2>Regiões para consulta</h2><div class="tag-list"><span class="tag">São João</span><span class="tag">Shiraiva</span><span class="tag">Vale do Sol</span><span class="tag">Campus 2</span><span class="tag">Jardim Tropical</span><span class="tag">Jardim Prudentino</span><span class="tag">Jardim Novo Prudentino</span><span class="tag">Ana Jacinta</span><span class="tag">Mário Amato</span><span class="tag">Damha I a IV</span><span class="tag">Monte Carlo</span><span class="tag">Parque Cedral</span><span class="tag">Residencial Buriti</span></div><p>Não encontrou seu bairro? Envie sua localização para consultar o atendimento.</p></div><aside class="aside-box"><h3>Consulte pelo WhatsApp</h3><p>Envie modelo, ano e motor do veículo, além do bairro em Presidente Prudente. Confirmamos a opção adequada e a disponibilidade.</p><a class="button" href="WA_LINK" target="_blank" rel="noopener">Consultar meu bairro</a></aside></div></section>
<section class="section alt"><div class="wrap image-text"><img src="/assets/bateria-moura.jpg" width="900" height="1600" loading="lazy" alt="Bateria Moura instalada em veículo atendido pela JF Baterias"><div><div class="eyebrow">Diagnóstico antes da troca</div><h2 class="section-title">Bateria ou <span>alternador?</span></h2><p class="copy">Partida lenta, luzes fracas e falhas elétricas podem ter mais de uma causa. Testar a bateria e o sistema de carga ajuda a escolher o próximo passo.</p><a class="text-link" href="/teste-de-bateria-e-alternador">Saiba mais sobre os testes</a></div></div></section>
<section class="section"><div class="wrap"><div class="section-head"><h2 class="section-title">Dúvidas sobre <span>Presidente Prudente</span></h2></div><div class="faq"><details><summary>A JF Baterias atende meu bairro em Presidente Prudente?</summary><p>Atendemos diversos bairros de Presidente Prudente. Envie sua localização pelo WhatsApp para confirmar a disponibilidade.</p></details><details><summary>Vocês fazem teste antes da troca?</summary><p>Sim. Verificamos a bateria e o sistema de carga para orientar a substituição quando necessária.</p></details></div></div></section>
<section class="cta-band"><div class="wrap cta-grid"><div><h2>Precisa de bateria em Prudente?</h2><p>Consulte a entrega para seu bairro e a bateria do seu veículo.</p></div><a class="button" href="WA_LINK" target="_blank" rel="noopener">Chamar a JF Baterias</a></div></section>
'@
Write-Page -Path 'bateria-delivery-presidente-prudente' -Title 'Bateria Delivery em Presidente Prudente | JF Baterias' -Description 'Bateria delivery em Presidente Prudente com entrega, instalação e teste no local. Consulte atendimento para seu bairro e a bateria do seu veículo.' -Body $prudente.Replace('WA_LINK',$Wa) -Type 'Service' -Faq $prudenteFaq
function Write-Detail {
  param([string]$Path,[string]$Title,[string]$Description,[string]$Eyebrow,[string]$H1,[string]$Intro,[string]$Heading,[string]$P1,[string]$P2,[string]$ListHeading,[array]$Items,[string]$Image,[string]$Alt,[string]$ImageHeading,[string]$ImageText,[string]$Action)
  $list = ($Items | ForEach-Object { "<li>$_</li>" }) -join ''
  $imageClass = if ($Image -like '*-produto*') { ' class="product-photo"' } else { '' }
  $body = @"
<section class="page-hero"><div class="wrap"><div class="breadcrumb"><a href="/">Início</a> / $H1</div><div class="eyebrow">$Eyebrow</div><h1>$H1</h1><p>$Intro</p><a class="button" href="$Wa" target="_blank" rel="noopener">$Action</a></div></section>
<section class="section"><div class="wrap detail-grid"><div><h2>$Heading</h2><p>$P1</p><p>$P2</p><div class="note">Informe modelo, ano e motor do veículo para consultar a opção adequada e a disponibilidade.</div></div><aside class="aside-box"><h3>$ListHeading</h3><ul>$list</ul><a class="button" href="$Wa" target="_blank" rel="noopener">Consultar no WhatsApp</a></aside></div></section>
<section class="section alt"><div class="wrap image-text"><img$imageClass src="$Image" width="900" height="600" loading="lazy" alt="$Alt"><div><div class="eyebrow">JF Baterias</div><h2 class="section-title">$ImageHeading</h2><p class="copy">$ImageText</p><a class="text-link" href="$Wa" target="_blank" rel="noopener">Enviar dados do veículo</a></div></div></section>
<section class="section"><div class="wrap"><div class="section-head"><h2 class="section-title">Atendimento em <span>Álvares Machado e Presidente Prudente</span></h2><p>Consulte entrega e instalação para sua localização. A disponibilidade de modelos e amperagens varia.</p></div><div class="areas"><div class="area-card"><h3>Álvares Machado</h3><a class="text-link" href="/bateria-delivery-alvares-machado">Ver atendimento em Álvares Machado</a></div><div class="area-card"><h3>Presidente Prudente</h3><a class="text-link" href="/bateria-delivery-presidente-prudente">Ver atendimento em Presidente Prudente</a></div></div></div></section>
<section class="cta-band"><div class="wrap cta-grid"><div><h2>Precisa de uma bateria?</h2><p>Fale com a JF Baterias pelo WhatsApp: (18) 99111-4834.</p></div><a class="button" href="$Wa" target="_blank" rel="noopener">Pedir bateria</a></div></section>
"@
  Write-Page -Path $Path -Title $Title -Description $Description -Body $body
}
Write-Detail -Path 'instalacao-de-bateria' -Title 'Instalação de Bateria no Local | JF Baterias' -Description 'Instalação de bateria automotiva no local em Álvares Machado e Presidente Prudente. A JF Baterias entrega, instala e testa o sistema.' -Eyebrow 'Serviço no local' -H1 'Instalação de bateria no local' -Intro 'A bateria pode ser entregue e instalada onde seu veículo estiver. Consulte o atendimento para sua localização.' -Heading 'Como funciona a instalação' -P1 'Depois de confirmar o modelo e a bateria correta, combinamos a entrega no local. Retiramos a bateria antiga, instalamos a nova e conferimos a partida e o sistema de carga.' -P2 'Veículos modernos podem exigir atenção a sistemas eletrônicos e procedimentos adicionais. A necessidade é avaliada conforme o modelo; não há uma rotina única para todos os carros.' -ListHeading 'Antes de chamar, envie' -Items @('Modelo e ano do veículo','Motorização, se souber','Localização','Sintomas apresentados') -Image '/assets/bateria-instalada.jpg' -Alt 'Bateria instalada no compartimento do motor por atendimento da JF Baterias' -ImageHeading 'A troca feita <span>com cuidado.</span>' -ImageText 'A aplicação correta depende de capacidade, dimensões, polaridade e tecnologia da bateria. Nossa equipe verifica essas informações antes de indicar uma opção.' -Action 'Consultar instalação'
Write-Detail -Path 'teste-de-bateria-e-alternador' -Title 'Teste de Bateria e Alternador | JF Baterias' -Description 'Teste de bateria e sistema de carga em Álvares Machado e Presidente Prudente. Descubra se a falha na partida pode estar na bateria ou no alternador.' -Eyebrow 'Diagnóstico' -H1 'Teste de bateria e alternador' -Intro 'Nem toda falha na partida pede uma bateria nova. Verificamos a bateria e o sistema de carga para orientar o próximo passo.' -Heading 'O que os testes ajudam a identificar' -P1 'Uma bateria fraca pode causar partida lenta ou impedir o veículo de ligar. O alternador também precisa carregar o sistema corretamente. A avaliação desses componentes ajuda a entender a causa do problema antes da substituição.' -P2 'Se a bateria precisar ser trocada, consultamos o modelo adequado e podemos fazer a instalação no local. Se houver indício de outro defeito elétrico, explicamos o resultado da verificação.' -ListHeading 'Sinais comuns' -Items @('Partida lenta','Luzes enfraquecidas','Falhas elétricas','Bateria descarregando novamente') -Image '/assets/scanner-automotivo.jpg' -Alt 'Equipamento de diagnóstico automotivo utilizado pela JF Baterias' -ImageHeading 'Diagnóstico antes <span>da decisão.</span>' -ImageText 'O teste da bateria e do sistema de carga evita uma troca precipitada e ajuda a encontrar a solução correta para o veículo.' -Action 'Consultar teste'
Write-Detail -Path 'bateria-moura' -Title 'Bateria Moura em Álvares Machado e Presidente Prudente | JF Baterias' -Description 'Consulte bateria Moura para seu veículo com entrega e instalação em Álvares Machado e Presidente Prudente. Confira disponibilidade pelo WhatsApp.' -Eyebrow 'Marcas' -H1 'Bateria Moura para seu veículo' -Intro 'Consulte modelos Moura compatíveis com seu carro, moto ou veículo pesado, conforme disponibilidade.' -Heading 'Qual Moura é adequada?' -P1 'A linha correta depende das especificações do veículo: capacidade, dimensões, posição dos polos e tecnologia exigida. Envie modelo, ano e motor para verificarmos as opções disponíveis.' -P2 'A JF Baterias pode entregar e instalar a bateria no local em Álvares Machado e em regiões atendidas de Presidente Prudente. Também verificamos a bateria e o sistema de carga.' -ListHeading 'Na consulta, verificamos' -Items @('Aplicação para o veículo','Amperagem e tecnologia','Disponibilidade','Entrega e instalação') -Image '/assets/bateria-moura-produto-v2.webp' -Alt 'Bateria Moura M70KE' -ImageHeading 'Moura com <span>instalação no local.</span>' -ImageText 'Escolher a bateria exige compatibilidade com o veículo. Consulte a aplicação antes da entrega para evitar uma peça inadequada.' -Action 'Consultar Moura'
Write-Detail -Path 'bateria-heliar' -Title 'Bateria Heliar em Álvares Machado e Presidente Prudente | JF Baterias' -Description 'Consulte bateria Heliar com entrega, teste e instalação no local em Álvares Machado e Presidente Prudente. Informe seu veículo pelo WhatsApp.' -Eyebrow 'Marcas' -H1 'Bateria Heliar para seu veículo' -Intro 'A JF Baterias consulta a opção Heliar compatível e a disponibilidade de entrega para sua região.' -Heading 'Aplicação correta, sem adivinhação' -P1 'Carros, motos e veículos pesados usam baterias com especificações diferentes. Mesmo veículos parecidos podem exigir capacidade ou tecnologia distintas. Modelo, ano e motor ajudam a identificar a opção Heliar adequada.' -P2 'Se houver disponibilidade, levamos a bateria ao local combinado, instalamos e conferimos a partida. Também podemos verificar o sistema de carga para entender se há falha no alternador.' -ListHeading 'Informe pelo WhatsApp' -Items @('Modelo do veículo','Ano','Motor','Bairro ou localização') -Image '/assets/bateria-heliar-produto-v2.jpg' -Alt 'Bateria Heliar SLI' -ImageHeading 'Heliar com <span>atendimento delivery.</span>' -ImageText 'Consulte as condições de garantia do fabricante e o parcelamento para a opção disponível para seu veículo.' -Action 'Consultar Heliar'
Write-Detail -Path 'bateria-eletran' -Title 'Bateria Eletran em Álvares Machado e Presidente Prudente | JF Baterias' -Description 'Consulte bateria Eletran para seu veículo com entrega e instalação gratuitas em horário comercial em Álvares Machado e Presidente Prudente.' -Eyebrow 'Marcas' -H1 'Bateria Eletran para seu veículo' -Intro 'Consulte a bateria Eletran compatível com seu veículo e a disponibilidade para sua região.' -Heading 'Qual Eletran é adequada?' -P1 'A bateria correta depende da capacidade, das dimensões, da posição dos polos e da tecnologia exigida pelo veículo. Envie modelo, ano e motor para verificarmos a opção disponível.' -P2 'A JF Baterias atende Álvares Machado e regiões de Presidente Prudente. Em horário comercial, a entrega e a instalação são gratuitas na região atendida.' -ListHeading 'A consulta inclui' -Items @('Compatibilidade com o veículo','Amperagem disponível','Condições de garantia','Entrega para sua região') -Image '/assets/bateria-eletran-produto-v2.webp' -Alt 'Bateria Eletran Truck' -ImageHeading 'Eletran com <span>instalação no local.</span>' -ImageText 'Consulte a aplicação e a disponibilidade da bateria Eletran para seu veículo antes de fechar o pedido.' -Action 'Consultar Eletran'
$privacy = @'
<section class="page-hero"><div class="wrap"><div class="breadcrumb"><a href="/">Início</a> / Privacidade</div><h1>Política de <span>Privacidade</span></h1><p>Como os dados enviados pelo site são usados.</p></div></section>
<section class="section"><div class="wrap faq"><h2>Informações enviadas</h2><p class="copy">O formulário deste site monta uma mensagem no seu WhatsApp com nome, dados do veículo e bairro. Esses dados não são armazenados pelo site. Você decide se deseja enviar a mensagem.</p><h2>Contato</h2><p class="copy">Após o envio, a conversa ocorre pelo WhatsApp para consultar bateria, preço, disponibilidade e atendimento. Para dúvidas sobre suas informações, fale com a JF Baterias pelo número <a class="text-link" href="tel:+5518991114834">(18) 99111-4834</a>.</p><h2>Serviços de terceiros</h2><p class="copy">Ao abrir o WhatsApp, aplicam-se também as políticas da plataforma. Este site não usa formulários de cadastro nem coleta pagamento online.</p></div></section>
'@
Write-Page -Path 'politica-de-privacidade' -Title 'Política de Privacidade | JF Baterias' -Description 'Saiba como os dados informados no site da JF Baterias são usados na consulta pelo WhatsApp.' -Body $privacy
$notFound = @'
<section class="empty-page"><div class="wrap"><div class="eyebrow">Página não encontrada</div><h1 class="section-title">Essa página não existe.</h1><p class="copy">Volte ao início ou fale com a JF Baterias para consultar uma bateria.</p><a class="button" href="/">Voltar ao início</a></div></section>
'@
Write-Page -Path '404' -Title 'Página não encontrada | JF Baterias' -Description 'Volte à página inicial da JF Baterias.' -Body $notFound
Copy-Item (Join-Path $Root '404\index.html') (Join-Path $Root '404.html') -Force
$urls = @('','bateria-delivery-alvares-machado','bateria-delivery-presidente-prudente','instalacao-de-bateria','teste-de-bateria-e-alternador','bateria-moura','bateria-heliar','bateria-eletran','politica-de-privacidade')
$entries = ($urls | ForEach-Object { "<url><loc>$Origin/$_</loc></url>" }) -join ''
[System.IO.File]::WriteAllText((Join-Path $Root 'sitemap.xml'),('<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' + $entries + '</urlset>'),(New-Object System.Text.UTF8Encoding($false)))
[System.IO.File]::WriteAllText((Join-Path $Root 'robots.txt'),"User-agent: *`nAllow: /`nSitemap: $Origin/sitemap.xml`n",(New-Object System.Text.UTF8Encoding($false)))
Write-Output "Generated $($urls.Count) public pages."
