let url = window.location.pathname + window.location.search
$('.choose-filter').each(function () {
    if ($(this).find('a').attr('href') === url) {
        $(this).addClass('active');
        $(this).find('a').css('color', '#ee4d2d');
    } else {
        $(this).removeClass('active');
        $(this).find('a').css('color', '');
    }
});

$('.subnav').each(function () {
    if ($(this).attr('href') === url) {
        //$(this).addClass('active');
        $(this).closest('.dropdown').find('.choose-filter').addClass('active');
        $(this).closest('.dropdown').find('.choose-filter').html($(this).text() + '<span class="caret"></span>');
    } else {
        $(this).removeClass('active');
    }
});

//ADD WISHLIST
//thêm vào giỏ hàng
