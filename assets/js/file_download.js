document.addEventListener('DOMContentLoaded', function() {
  function save(e) {
    e.preventDefault()
    const svg = document.querySelector('#maze svg').cloneNode(true)

    svg.setAttribute('version', '1.1')
    svg.setAttribute('xmlns', 'http://www.w3.org/2000/svg')

    const content = svg.outerHTML;
    const blob = new Blob([content], {type: "image/svg+xml"});

    const a = document.createElement('a');
    a.style.display = 'none';
    a.setAttribute('download', e.target.getAttribute('download'));
    a.href = URL.createObjectURL(blob);
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
  }

  const link = document.querySelector('#download-maze')
  link.addEventListener('click', save)

  window.addEventListener('beforeunload', (event) => {
    link.removeEventListener('click', save)
  })
})
