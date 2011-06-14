// placeholder.js
(function($) {
        $.fn.placeholder=function(description){
                return this.each(function(){
                        var input=$(this);
                        input
                                .bind("blur.placeholder",function(){
                                        input.val(input.val()||description);
                                })
                                .bind("focus.placeholder",function(){
                                        if(input.val()==description)
                                                input.val('');
                                })
                                .trigger("blur.placeholder");
                });
        };
})(jQuery);

