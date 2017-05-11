;(function ($) {
  $(document).ready(function () {
    $('.nav [href^="#"]').click(function () {
      var scrolledTo = ($($(this).attr('href'))[0])
          ? $($(this).attr('href'))[0].offsetTop
          : 0;
      $("html, body").stop().animate({
        scrollTop: scrolledTo
      }, 500);
      if ($(this).closest('.navbar-nav')[0] && !$(this).parent('li').hasClass('active')) {
        $(this).closest('.navbar-nav').children('li').each(function () {
          $(this).removeClass('active');
        });
        $(this).parent('li').addClass('active');
      } else {
        $('[href^="#"]').each(function () {
          $(this).removeClass('active');
        });
        $(this).addClass('active');
      }
      return false;
    });
    $('[data-toggle="tooltip"]').tooltip({
      container: "body"
    });
    $('body').scrollspy({ target: '#bs-example-navbar-collapse-1' });
  });
})(jQuery);
