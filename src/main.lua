
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath(cc.FileUtils:getInstance():getWritablePath(), true)

require "socket"
require "socket.http"
require "config"
require "cocos.init"

local function main()
    require("app.MyApp"):create():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
		local logText = string.format(
	[[----------------------------------------
	LUA ERROR: %s
	%s
	----------------------------------------]], tostring(msg), debug.traceback())
    print(logText)
end
