const modelSelect = document.getElementById('model-select');
const modelFrame = document.getElementById('model-frame');
const modelOpen = document.getElementById('model-open');
modelSelect.addEventListener('change', () => {
  modelFrame.src = modelSelect.value;
  modelFrame.title = 'Modelo Archify · ' + modelSelect.selectedOptions[0].text;
  modelOpen.href = modelSelect.value;
});

const tableSearch = document.getElementById('table-search');
const tableResults = document.getElementById('table-results');
const tableGroups = [...document.querySelectorAll('.inventory-group')].map(group => ({
  group,
  rows: [...group.querySelectorAll('li')],
}));
tableSearch.addEventListener('input', () => {
  const query = tableSearch.value.trim().toLowerCase();
  let matches = 0;
  for (const {group, rows} of tableGroups) {
    let groupMatches = 0;
    for (const row of rows) {
      row.hidden = !row.querySelector('code').textContent.toLowerCase().includes(query);
      if (!row.hidden) groupMatches++;
    }
    group.hidden = groupMatches === 0;
    if (query && groupMatches) group.open = true;
    matches += groupMatches;
  }
  tableResults.hidden = !query;
  tableResults.textContent = matches ? 'Tablas encontradas: ' + matches : 'Sin coincidencias.';
});
