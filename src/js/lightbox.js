$( document ).ready( function() {
  lightbox();
} );


function lightbox() {
  var links = $( 'a[rel^=lightbox]' );
  var overlay = $( jQuery( '<div id="overlay" style="display: none"></div>' ) );
  var container = $( jQuery( '<div id="lightbox" style="display: none"></div>' ) );
  var target = $( jQuery( '<div class="target"></div>' ) );
  var close = $( jQuery( '<a href="#close" class="close">&times; Close</a>' ) );
  var prev = $( jQuery( '<a href="#prev" class="prev">&laquo; Previous</a>' ) );
  var next = $( jQuery( '<a href="#next" class="next">Next &raquo;</a>' ) );
}