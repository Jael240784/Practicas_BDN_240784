const modelSelect = document.getElementById('model-select');
const modelFrame = document.getElementById('model-frame');
const modelOpen = document.getElementById('model-open');
modelSelect.addEventListener('change', () => {
  modelFrame.src = modelSelect.value;
  modelFrame.title = 'Modelo Archify · ' + modelSelect.selectedOptions[0].text;
  modelOpen.href = modelSelect.value;
});
