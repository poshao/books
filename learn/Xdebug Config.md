# 配置Xdebug 调试PHP程序

## Xdebug 插件安装

## Xdebug在php.ini中的配置
``` ini
;下载的xdebug.dll文件目录
zend_extension = "path/php_xdebug.dll"

;远程调试开关
xdebug.remote_enable = 1

;自动启动远程调试模式，默认: 0
;通过指定参数启动调试
; GET/POST => XDEBUG_SESSION_START=session_name
; Cookies => XDEBUG_SESSION=session_name
xdebug.remote_autostart = 0

;调试控制协议，默认: dbgp (仅支持此协议)
xdebug.remote_handler=dbgp

;客户端(php插件xdebug)请求地址，默认: localhost
xdebug.remote_host=127.0.0.1

;客户端请求端口， 默认: 9000
xdebug.remote_port=9000
xdebug.remote_mode=req

;将以下指定session_name请求交给服务端(IDE监听程序)处理, 默认: *complex*
xdebug.idekey=xdebug

;日志文件路径, 默认: 空字符串
xdebug.remote_log="xdebug.log"
xdebug.show_local_vars=9
xdebug.show_mem_delta=0

;追踪功能开关，默认: 0
;当设置为1时可以通过在请求增加参数启动调用追踪功能
;GET/POST/Cookie => XDEBUG_TRACE
xdebug.trace_enable_trigger=0

;追踪指定值的请求，默认: "", 参照 XDEBUG_TRACE 的设定值
xdebug.trace_enable_trigger_value=""

;追踪结果输出目录，默认: /tmp
xdebug.trace_output_dir=/tmp

;追踪结果输出文件名，默认: trace.%c
; %c=> crc32 of the current working directory
; %p=> pid
; %r=> random number
; %s=> 脚本文件路径
; %t=> timestamp (seconds)
; %u=> timestamp (microseconds)
; %H=> $_SERVER['HTTP_HOST']
; %R=> $_SERVER['REQUEST_URI']
; %U=> $_SERVER['UNIQUE_ID'] 3
; %S=> session_id (from $_COOKIE if set)
; %%=> 转义 %
xdebug.trace_output_name=""

;自动启动追踪功能, 默认: 0
xdebug.auto_trace=0
xdebug.trace_format=0
```