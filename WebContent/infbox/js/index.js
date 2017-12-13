//滚动条
function AutoScroll(obj) {

            $(obj).find("ul:first").animate({
                marginTop: "-29px"
            }, 600, function() {
                $(this).css({ marginTop: "0px" }).find("li:first").appendTo(this);
            });
        }
        $(document).ready(function() {
            var myar = setInterval('AutoScroll("#endlist")', 600)
            $("#endlist").hover(function() { clearInterval(myar); }, function() { myar = setInterval('AutoScroll("#endlist")', 1000) }); //当鼠标放上去的时候，滚动停止，鼠标离开的时候滚动开始
        	var myar2 = setInterval('AutoScroll("#login-list")', 600)
            $("#login-list").hover(function() { clearInterval(myar); }, function() { myar2 = setInterval('AutoScroll("#login-list")', 1000) }); //当鼠标放上去的时候，滚动停止，鼠标离开的时候滚动开始
        });




