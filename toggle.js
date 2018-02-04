    jQuery(function() {
        jQuery('#showall').click(function() {
          jQuery('.targetDiv').show();
        });
        jQuery('.showSingle').click(function() {
          jQuery('#instructions' + $(this).attr('target')).toggle();      
        });
      });