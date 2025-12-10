const body = document.querySelector('div.body')
const body_width = window.getComputedStyle(body).maxWidth;

// Create the floating div
const floatingDiv = document.createElement('div');
floatingDiv.id = 'floatingDiv';
floatingDiv.style.position = 'fixed';
floatingDiv.style.right = '0';
floatingDiv.style.top = '50%';
floatingDiv.style.transform = 'translateY(-50%)';
floatingDiv.style.width = ;
floatingDiv.style.height = '700px';
document.body.appendChild(floatingDiv);

// Function to check window size and toggle the display of the floating div
function checkWindowSize() {
    if (window.innerWidth > 1300) {
        floatingDiv.style.display = 'block';
    } else {
        floatingDiv.style.display = 'none';
    }
}

// Check window size on load
window.addEventListener('load', checkWindowSize);

// Check window size on resize
window.addEventListener('resize', checkWindowSize);

const ol = document.createElement('ol');
Array.from(document.querySelectorAll('dt.sig.sig-object.py')).forEach((el) => {
    const li = document.createElement('li');
    const a = document.createElement('a');
    a.href = `#${el.id}`;
    a.textContent = el.id;
    li.appendChild(a);
    ol.appendChild(li);
})

floatingDiv.appendChild(ol);
