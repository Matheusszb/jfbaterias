const menuButton = document.querySelector('.menu-toggle');
const nav = document.querySelector('.nav');
menuButton?.addEventListener('click', () => {
  const open = nav.classList.toggle('open');
  menuButton.setAttribute('aria-expanded', String(open));
});
nav?.querySelectorAll('a').forEach(link => link.addEventListener('click', () => {
  nav.classList.remove('open');
  menuButton?.setAttribute('aria-expanded', 'false');
}));
document.querySelector('#consult-form')?.addEventListener('submit', event => {
  event.preventDefault();
  const data = new FormData(event.currentTarget);
  const lines = [
    'Olá, JF Baterias! Vim pelo site e gostaria de consultar uma bateria.',
    'Nome: ' + data.get('nome'),
    'Veículo: ' + data.get('veiculo'),
    'Ano: ' + data.get('ano'),
    'Motor: ' + (data.get('motor') || 'não informado'),
    'Bairro/localização: ' + data.get('bairro')
  ];
  window.open('https://wa.me/5518991114834?text=' + encodeURIComponent(lines.join('\n')), '_blank', 'noopener');
});
