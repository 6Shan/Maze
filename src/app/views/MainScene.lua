
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

require "app.Utils"
require "app.Const"
require "app.GameClient"
-- require "app.config.DictumConfig"

function MainScene:onCreate()
    -- -- add background image
    local _layer = display.newLayer(cc.c4b(255,255,255,255))
            :addTo(self)
    display.newSprite("mgd_17.png")
    	:move(display.cx, display.cy + 200)
        :addTo(_layer)

    self.upBtn = ccui.Button:create("mgd_29.png")
                    :setScale(1)
                    :move(display.cx, display.bottom + 200)
                    :addTo(self)
                    :setTag(Const.up)
    self.upBtn:addTouchEventListener(function (sender, event)
            if event == ccui.TouchEventType.ended then
                local map = self:getApp():createView("LevelScene")
                map:showWithScene()
            end
        end)
    local _size = self.upBtn:getContentSize()
    cc.Label:createWithSystemFont("向前走", "Arial", 30)
                :setColor(cc.c3b(0,0,0))
                :move(_size.width / 2, _size.height + 15)
                :addTo(self.upBtn)
    
    self.leftBtn = ccui.Button:create("mgd_30.png")
                    :setScale(-1, 1)
                    :move(display.cx - 180, display.bottom + 110)
                    :addTo(self)
                    :setTag(Const.left)
    self.leftBtn:addTouchEventListener(function (sender, event)
            if event == ccui.TouchEventType.ended then
                GameClient.editMapData = {}
                local map = self:getApp():createView("EditScene")
                map:initPanel()
                map:showWithScene()
            end
        end)
    _size = self.leftBtn:getContentSize()
    cc.Label:createWithSystemFont("向左走", "Arial", 30)
                :setScaleX(-1)
                :move(_size.width / 2 - 20, _size.height)
                :setColor(cc.c3b(0,0,0))
                :addTo(self.leftBtn)
    
    self.rightBtn = ccui.Button:create("mgd_30.png")
                    :setScale(1)
                    :move(display.cx + 180, display.bottom + 110)
                    :addTo(self)
                    :setTag(Const.right)
    self.rightBtn:addTouchEventListener(function (sender, event)
            if event == ccui.TouchEventType.ended then
                local map = self:getApp():createView("MapScene")
                map:init()
                map:showWithScene()
            end
        end)
    cc.Label:createWithSystemFont("向右走", "Arial", 30)
            :move(_size.width / 2 - 20, _size.height)
            :setColor(cc.c3b(0,0,0))
            :addTo(self.rightBtn)

    self.nameLabel = cc.Label:createWithSystemFont("玩家名字", "Arial", 30)
                    :move(display.cx, display.bottom + 30)
                    :addTo(self)
                    :setColor(cc.c3b(125,125,125))
    local fun = function(touch,event)
        -- local rect = event:getCurrentTarget():getBoundingBox()
        -- local pos = touch:getLocation()
        -- rectContainsPoint
        if cc.rectContainsPoint(event:getCurrentTarget():getBoundingBox(), touch:getLocation()) then
            return true
        else
            return false
        end
    end
    local listener = cc.EventListenerTouchOneByOne:create()
    listener:registerScriptHandler(fun, cc.Handler.EVENT_TOUCH_BEGAN)
    listener:registerScriptHandler(function (touch, event) self:changeName("修改名字") end,cc.Handler.EVENT_TOUCH_ENDED)
    
    local eventDispatcher = self.nameLabel:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.nameLabel)

end

function MainScene:checkName()
    self:changeName("这是属于您的故事请输入您的名字")
end

function MainScene:changeName(string)
    print(string,"spfdopsdpo")
    if self.nameLayer then return end
    self.nameLayer = display.newLayer(cc.c4b(0,0,0,125))
                    :addTo(self)
    local _layer = display.newLayer(cc.c4b(255,255,255,255))
            :addTo(self.nameLayer)
            :move(display.cx-250, display.cy-180)
            :setContentSize(cc.size(500, 360))
    local _rect = _layer:getBoundingBox()
    _layer:onTouch(function (event)
        if event.name == "began" then
            if cc.rectContainsPoint(_rect, cc.p(event.x, event.y)) then
                return false
            else
                return true
            end
        elseif event.name == "ended" then
            self.nameLayer:removeSelf()
            self.nameLayer = nil
        end
    end)
    _layer:setSwallowsTouches(true)
    
    cc.Label:createWithSystemFont(string, "Arial", 32)
                :addTo(_layer)
                :move(250, 280)
                :setDimensions(280, 66)
                :setColor(cc.c3b(0,0,0))
                :setAlignment(cc.TEXT_ALIGNMENT_CENTER)

    local _box = ccui.EditBox:create(cc.size(200, 40), "mgd_13.png")
                :addTo(_layer)
                :move(250, 200)
                :setFontColor(cc.c3b(0,0,0))
                :setPlaceHolder("sdofso")
                :setPlaceholderFontColor(cc.c3b(125,125,125))
                :setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_CENTER)
                :setInputFlag(cc.EDITBOX_INPUT_FLAG_INITIAL_CAPS_WORD)

    ccui.Button:create("mgd_21.png")
                :setContentSize(180, 80)
                :addTo(_layer)
                :setScale9Enabled(true)
                :move(250, 60)
                :setTitleText("确定")
                :setTitleColor(cc.c3b(0,0,0))
                :setTitleFontSize(30)
                :addTouchEventListener(
                    function(sender, event) 
                        if event == ccui.TouchEventType.ended then
                            self.nameLabel:setString(_box:getText())
                            self.nameLayer:removeSelf()
                            self.nameLayer = nil
                        end
                    end)

end

return MainScene
