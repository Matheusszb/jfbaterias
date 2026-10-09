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


// Revela os blocos uma vez quando entram na tela. Sem JS ou com movimento
// reduzido, todo o conteúdo permanece visível normalmente.
const reduceMotion = window.matchMedia?.('(prefers-reduced-motion: reduce)').matches;
if (!reduceMotion && 'IntersectionObserver' in window) {
  const revealTargets = document.querySelectorAll(
    '.home-section .home-heading, .vehicle-card, .brand-tile, ' +
    '.service-photo, .service-text, .area-links a, .faq details, ' +
    '.section .wrap, .cta-grid'
  );
  const revealObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach(entry => {
      if (!entry.isIntersecting) return;
      entry.target.classList.add('is-visible');
      observer.unobserve(entry.target);
    });
  }, { threshold: 0.08, rootMargin: '0px 0px -28px 0px' });

  revealTargets.forEach((element, index) => {
    element.classList.add('reveal');
    element.style.setProperty('--reveal-delay', `${index % 3 * 70}ms`);
    revealObserver.observe(element);
  });
}
