/*
  Code for translating Markdown to HTML using Ajax
*/
var setup = function() {

  // Find the notes field on the page
  var $notes = $('#note_body');

  // find the live preview on the page
  var $preview = $('#preview');

  // event listener
  $notes.on('input', function(event){
    var textToTransform = $(this).val();

    // send response
    $.ajax({
      method: "POST",
      url: "/notes/process_markdown",
      data: { text: textToTransform }
    })
      .done(function( msg ) {
        // got response. Place result in the preview box
        $preview.html(msg);
      });

  });
};

// must watch BOTH events because Rails uses Turbolinks to
// reload pages.
$(document).on('ready page:load', setup);
