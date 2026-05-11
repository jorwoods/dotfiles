let replace = document.querySelector('#affixed-right-container');

let headings = Array.from(document.querySelectorAll('div.content .heading-anchor')).filter(
    e => !e.id.includes('in-this-article')
).map(
    h => `<li><a href="#${h.id}">${h.innerText}</a></li>`
);

let links = headings.join('\n');
replace.innerHTML = `<ol>${links}</ol>`;
replace.style.overflowY = 'auto';
