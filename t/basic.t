# vi:ft=perl
use lib 'lib';
use Test::Nginx::Socket;

repeat_each(2);

plan tests => blocks() * repeat_each() * 2;

run_tests();

__DATA__

=== TEST 1: internal only
--- config
	location /lua {
		set_by_lua $res "function fib(n) if n > 2 then return fib(n-1)+fib(n-2) else return 1 end end return fib(10)";
		echo $res;
	}
--- request
GET /lua
--- response_body
55



=== TEST 2: internal script with argument
--- config
	location /lua {
		set_by_lua $res "return ngx.arg[1]+ngx.arg[2]" $arg_a $arg_b;
		echo $res;
	}
--- request
GET /lua?a=1&b=2
--- response_body
3

