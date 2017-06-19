
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

require "app.Utils"
require "app.Const"
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
                    :move(display.cx, display.bottom + 150)
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
                    :move(display.cx - 180, display.bottom + 60)
                    :addTo(self)
                    :setTag(Const.left)
    self.leftBtn:addTouchEventListener(function (sender, event)
            if event == ccui.TouchEventType.ended then
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
                    :move(display.cx + 180, display.bottom + 60)
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
end

return MainScene
