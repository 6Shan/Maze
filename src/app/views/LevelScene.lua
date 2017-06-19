local LevelScene = class("LevelScene", cc.load("mvc").ViewBase)

function LevelScene:onCreate()
    self.btnList = {}
    cc.LayerColor:create(cc.c4b(0, 255, 255, 155))
        :addTo(self)


    self.downBtn = ccui.Button:create("mgd_29.png")
                    :setScale(1, -1)
                    :move(display.cx, display.bottom + 50)
                    :addTo(self)
                    :setTag(Const.down)
    self.downBtn:addTouchEventListener(function (sender, event) 
            if event == ccui.TouchEventType.ended then
                local map = self:getApp():createView("MainScene")
                map:showWithScene()
            end
        end)
    local _size = self.downBtn:getContentSize()
    cc.Label:createWithSystemFont("返回", "Arial", 30)
                :setScaleY(-1)
                :move(_size.width / 2, -15)
                :addTo(self.downBtn)
    local _config = Utils.getAllConfig("StroyConfig")
    for i=1,#_config do
        local _levelBtn = ccui.Button:create("mgd_14.png")
                        :move(display.cx, display.top - 110 * i + 30)
                        :setContentSize(480, 100)
                        :addTo(self)
                        :setScale9Enabled(true)
        _levelBtn:addTouchEventListener(function (sender, event) 
            if event == ccui.TouchEventType.ended then
                local map = self:getApp():createView("ReadyScene")
                map:init(_config[i].mapID)
                map:showWithScene()
            end
        end)
        cc.Label:createWithSystemFont(_config[i].title, "Arial", 30)
            :setTextColor(display.COLOR_BLACK)
            :move(240, 75)
            :addTo(_levelBtn)
        cc.Label:createWithSystemFont(_config[i].tip, "Arial", 30)
            :setTextColor(display.COLOR_BLACK)
            :move(240, 30)
            :addTo(_levelBtn)
    end
    -- local _sprite = _levelBtn:getRendererNormal()
    -- -- _sprite:setContentSize(480, 100)
    -- -- local _sprite = _levelBtn:getRendererClicked()
    -- -- _sprite:setContentSize(480, 100)
    -- -- local _sprite = _levelBtn:getRendererDisabled()
    -- -- _sprite:setContentSize(480, 100)


    -- _sprite = ccui.Scale9Sprite:create("mgd_14.png")
    --             :move(display.cx, display.top - 200)
    --             :addTo(self)
    -- _sprite:setContentSize(480, 100)


end

return LevelScene