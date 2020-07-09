//function burgerMenu() {

//    var x = document.getElementById("myLinks");
//    if (x.style.display === "block") {
//        x.style.display = "none";
//    } else {
//        x.style.display = "block";
//    }
//}

function goBack() {
    window.history.back();window.history.back();
}

function goBackPersonalPage() {
    window.location = 'personalFile.html';
}
//מעביר לסרטון שנבחר בדף הסרטונים הנגלל
var url = document.location.toString();
//if (url.match('#')) {
//    $('.nav-tabs a[href=#' + url.split('#')[1] + ']').tab('show');
//}

// Change hash for page-reload
$('.nav-tabs a').on('shown', function (e) {
    window.location.hash = e.target.hash;
});


$(document).ready(function () {
    $(document).delegate('.open', 'click', function (event) {
        $(this).addClass('oppenned');
        event.stopPropagation();
    })
    $(document).delegate('body', 'click', function (event) {
        $('.open').removeClass('oppenned');
    })
    $(document).delegate('.cls', 'click', function (event) {
        $('.open').removeClass('oppenned');
        event.stopPropagation();
    });


    var prevScrollpos = window.pageYOffset;
    window.onscroll = function () {
        var currentScrollPos = window.pageYOffset;
        if (prevScrollpos > currentScrollPos) {
            document.getElementById("goBackBtn").style.top = "0";
        } else {
            document.getElementById("goBackBtn").style.top = "-50px";
        }
        prevScrollpos = currentScrollPos;
    }

  


});