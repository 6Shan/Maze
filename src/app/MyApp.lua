
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())

    local targetPlatform = cc.Application:getInstance():getTargetPlatform()
	local function reload()
		local s = {
			"app.views.EditScene",
			"app.views.MapScene",
			"app.views.MainScene",
			"app.Const",
			"app.GameClient",
			"app.Utils",
			"app.module.Role",
			"app.views.ClickLayer",
			"app.module.Wall",
			-- "src/app/views/MapScene",
			-- "src/app/views/MainScene",
		}
		for i,v in ipairs(s) do
			print("value:", v, package.loaded[v])
			package.loaded[v] = nil
		end
		for i,v in ipairs(s) do
			require(v)
		end
		print("clearn")
	end	

	local function onKeyPressed(keyCode, event)
		if keyCode == cc.KeyCode.KEY_R then
			reload()
		end
	end
	if targetPlatform == cc.PLATFORM_OS_WINDOWS then
		local listener = cc.EventListenerKeyboard:create()	
		
		listener:registerScriptHandler(onKeyPressed, cc.Handler.EVENT_KEYBOARD_PRESSED )

		local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
		eventDispatcher:addEventListenerWithFixedPriority(listener, 1)
	end

end

return MyApp
