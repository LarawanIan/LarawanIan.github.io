let albumImages = [];
let currentImageIndex = 0;

function showContent(albumId) {
    // Hide the album grid
    document.getElementById('albums').classList.add('hidden');
    
    // Show the content container
    document.getElementById('content').classList.remove('hidden');

    // Hide all album content divs
    const albums = document.querySelectorAll('#content > div');
    albums.forEach(album => album.classList.add('hidden'));

    // Show the selected album content
    document.getElementById('album' + albumId).classList.remove('hidden');

    // Set up image click events for the selected album
    setupAlbumImages(albumId); 

    // Scroll to the top of the album content
    document.getElementById('content').scrollIntoView({ behavior: 'smooth' });
}

function setupAlbumImages(albumId) {
    const album = document.getElementById('album' + albumId);
    const images = album.querySelectorAll('.album-content img');

    images.forEach(img => {
        img.addEventListener('click', function() {
            showLightbox(this.src);
        });
    });
}

function showAlbums() {
    // Hide the content container
    document.getElementById('content').classList.add('hidden');

    // Show the album grid
    document.getElementById('albums').classList.remove('hidden');

    // Smooth scroll to the album grid
    const albumGrid = document.querySelector('.album-grid'); 
    albumGrid.scrollIntoView({ behavior: 'smooth' }); 
}

function showLightbox(src) {
    const lightbox = document.getElementById('lightbox');
    const lightboxImg = document.getElementById('lightbox-img');
    lightboxImg.src = src;
    lightbox.classList.add('visible');
    currentImageIndex = albumImages.indexOf(src); 
}

function hideLightbox() {
    const lightbox = document.getElementById('lightbox');
    lightbox.classList.remove('visible');
}

// Inside the lightbox div, add an event listener to prevent propagation
const lightbox = document.getElementById('lightbox');
lightbox.addEventListener('click', hideLightbox);

document.addEventListener("DOMContentLoaded", function() {
    const images = document.querySelectorAll("#portfoliosection img");
    images.forEach(img => {
        img.setAttribute("loading", "lazy");
    });
});