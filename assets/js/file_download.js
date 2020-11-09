document.addEventListener('DOMContentLoaded', function() {
  function save(e) {
    const svg = document.querySelector('#maze svg').cloneNode(true)

    svg.setAttribute('version', '1.1')
    svg.setAttribute('xmlns', 'http://www.w3.org/2000/svg')

    const content = svg.outerHTML;
    const blob = new Blob([content], {type: "image/svg+xml"});
    const a = e.target
    a.href = URL.createObjectURL(blob);
    a.click();
  }

  const link = document.querySelector('#download-maze')
  link.addEventListener('click', save)

  window.addEventListener('beforeunload', (event) => {
    link.removeEventListener('click', save)
  })
})
