// AT Protocol notes: the corner switch and the cards it shows.
// Where the window leaves room beside the text, cards sit in that margin next
// to their headings. Otherwise each heading gets an at:// marker that opens
// its card over the page. Either way the original text never moves.
// ES5 only: uglifier 2.1 minifies this file.
(function () {
  var STORAGE_KEY = 'tent-atproto-notes';
  var GAP = 17; // past the column's 15px padding, so 32px from the text
  var EDGE = 16; // kept clear at the window's right edge
  var MIN_WIDTH = 230;
  var MAX_WIDTH = 340;
  var STACK_GAP = 16;
  var STAGGER_MS = 45;

  var root = document.documentElement;
  var toggle = document.querySelector('.atproto-toggle');
  var cards = [].slice.call(document.querySelectorAll('.atproto-card'));
  if (!toggle || !cards.length) return;

  function isOn() {
    return root.classList.contains('atproto-on');
  }

  function markerFor(card) {
    return card.previousElementSibling;
  }

  function closeAll() {
    cards.forEach(function (card) {
      card.classList.remove('is-open');
      markerFor(card).setAttribute('aria-expanded', 'false');
    });
  }

  function layout() {
    var column = cards[0].offsetParent;
    if (!column) return;

    var room = root.clientWidth - column.getBoundingClientRect().right - GAP - EDGE;
    var side = room >= MIN_WIDTH;
    root.classList.toggle('atproto-side', side);
    root.classList.toggle('atproto-pop', !side);

    var bottom = -Infinity;
    cards.forEach(function (card) {
      var heading = document.getElementById(card.getAttribute('data-heading'));
      var marker = markerFor(card);
      marker.style.top = heading.offsetTop + (heading.offsetHeight - marker.offsetHeight) / 2 + 'px';

      if (!side) {
        card.style.left = '';
        card.style.width = '';
        card.style.top = heading.offsetTop + heading.offsetHeight + 8 + 'px';
        return;
      }

      // cards stack down the margin when sections are shorter than their cards
      var top = Math.max(heading.offsetTop, bottom + STACK_GAP);
      card.style.left = column.clientWidth + GAP + 'px';
      card.style.width = Math.min(MAX_WIDTH, room) + 'px';
      card.style.top = top + 'px';
      card.classList.toggle('is-shifted', top > heading.offsetTop + 4);
      bottom = top + card.offsetHeight;
    });
  }

  function setOn(on) {
    if (!on) closeAll();
    layout();
    // stagger the entrance, but leave together
    cards.forEach(function (card, i) {
      var delay = on ? Math.min(i, 8) * STAGGER_MS + 'ms' : '0ms';
      card.style.transitionDelay = delay;
      markerFor(card).style.transitionDelay = delay;
    });
    root.classList.toggle('atproto-on', on);
    toggle.setAttribute('aria-checked', on ? 'true' : 'false');
    try {
      localStorage.setItem(STORAGE_KEY, on ? 'on' : 'off');
    } catch (e) {}
  }

  var pending = null;
  function schedule() {
    if (pending) return;
    pending = requestAnimationFrame(function () {
      pending = null;
      layout();
    });
  }

  toggle.addEventListener('click', function () {
    setOn(!isOn());
  });

  cards.forEach(function (card) {
    var marker = markerFor(card);
    marker.addEventListener('click', function () {
      var opening = !card.classList.contains('is-open');
      closeAll();
      if (!opening) return;
      card.classList.add('is-open');
      marker.setAttribute('aria-expanded', 'true');
    });
  });

  document.addEventListener('click', function (event) {
    if (!event.target.closest('.atproto-card, .atproto-marker')) closeAll();
  });
  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') closeAll();
  });

  window.addEventListener('resize', schedule);
  window.addEventListener('load', schedule);
  if (document.fonts) document.fonts.ready.then(schedule);
  // the docs' example panels expand and collapse, which moves later headings
  if (window.ResizeObserver) new ResizeObserver(schedule).observe(cards[0].offsetParent || document.body);

  toggle.hidden = false;
  toggle.setAttribute('aria-checked', isOn() ? 'true' : 'false');
  layout();
  // transitions start only after the first layout, so a saved "on" fades in
  // at the right place instead of sliding from the top of the column
  requestAnimationFrame(function () {
    root.classList.add('atproto-ready');
  });
})();
