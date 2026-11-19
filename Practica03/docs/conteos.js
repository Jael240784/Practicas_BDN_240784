fetch('conteos.json').then(response => response.ok ? response.json() : null).then(snapshot => {
  if (!snapshot || typeof snapshot.capturado_utc !== 'string' || !snapshot.filas) return;
  const format = new Intl.NumberFormat('es-MX');
  for (const cell of document.querySelectorAll('[data-row-count]')) {
    const count = snapshot.filas[cell.dataset.rowCount];
    if (Number.isSafeInteger(count) && count >= 0) cell.textContent = format.format(count) + ' filas';
  }
  document.getElementById('snapshot-status').textContent = 'Última captura de filas: ' + snapshot.capturado_utc + ' UTC.';
}).catch(() => {});
