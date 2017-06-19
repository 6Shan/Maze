local MapScene = class("MapScene", cc.load("mvc").ViewBase)

local Role = require "app.module.Role"
local Wall = require "app.module.Wall"

function MapScene:onCreate()
    self.btnList = {}
    cc.LayerColor:create(cc.c4b(0, 255, 255, 255))
        :move(display.left, display.bottom)
        :setContentSize(cc.size(640, 960))
        :addTo(self)

    ccui.Button:create("mgd_31.png")
        :move(display.right, display.top)
        :setScale(0.5)
        :setAnchorPoint(1, 1)
        :addTo(self)
        :addTouchEventListener(function (sender, event) 
            -- local map = self:getApp():createView("MainScene")
            -- map:showWithScene()
            if event == ccui.TouchEventType.ended then
                self:newExitLayer()
            end
        end)
    
    self.upBtn = ccui.Button:create("mgd_29.png")
                    :setScale(1)
                    :move(display.cx, display.bottom + 150)
                    :addTo(self)
                    :setZoomScale(0)
                    :setTag(Const.up)
    self.upBtn:addTouchEventListener(function (sender, event)
            if event == ccui.TouchEventType.ended then
                self:hideWarn()
                self.mapLayer:goAhead()
            end
        end)
    self.btnList[Const.up] = self.upBtn
    local _size = self.upBtn:getContentSize()
    cc.Label:createWithSystemFont("向前走", "Arial", 30)
                :setColor(cc.c3b(0,0,0))
                :move(_size.width / 2, _size.height + 15)
                :addTo(self.upBtn)
    
    self.downBtn = ccui.Button:create("mgd_29.png")
                    :setScale(1, -1)
                    :move(display.cx, display.bottom + 50)
                    :addTo(self)
                    :setZoomScale(0)
                    :setTag(Const.down)
    self.downBtn:addTouchEventListener(function (sender, event) 
            if event == ccui.TouchEventType.ended then
                self:hideWarn()
                self.mapLayer:reverse()
            end
        end)
    self.btnList[Const.down] = self.downBtn
    cc.Label:createWithSystemFont("转身", "Arial", 30)
                :setScaleY(-1)
                :setColor(cc.c3b(0,0,0))
                :move(_size.width / 2, -15)
                :addTo(self.downBtn)
    self.downBtn:setVisible(false)

    self.leftBtn = ccui.Button:create("mgd_30.png")
                    :setScale(-1, 1)
                    :move(display.cx - 180, display.bottom + 60)
                    :addTo(self)
                    :setZoomScale(0)
                    :setTag(Const.left)
    self.leftBtn:addTouchEventListener(function (sender, event)
            if event == ccui.TouchEventType.ended then
                self:hideWarn()
                self.mapLayer:turn(Const.left)
            end
        end)
    self.btnList[Const.left] = self.leftBtn
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
                    :setZoomScale(0)
                    :setTag(Const.right)
    self.rightBtn:addTouchEventListener(function (sender, event)
            if event == ccui.TouchEventType.ended then
                self:hideWarn()
                self.mapLayer:turn(Const.right)
            end
        end)
    self.btnList[Const.right] = self.rightBtn
    cc.Label:createWithSystemFont("向右走", "Arial", 30)
            :move(_size.width / 2 - 20, _size.height)
            :setColor(cc.c3b(0,0,0))
            :addTo(self.rightBtn)

end
function MapScene:init(config)

    if not config then
        config = self:loadMap()
    end
    -- Utils.printTable(Utils.unserialize(self:loadMap()))
    -- local role = cc.Sprite:create("mgd_28.png")
    -- cc.Sprite:create("mgd_28.png")
    self.aheadDate = {}
    self.aheadDate.needWall = {}
    -- self.aheadDate.wallList = {}
    -- self.aheadDate.wallIndex = 1

    self.halfWalkHeight = Const.wallHeight /2
    self.mapCenter = cc.ClippingNode:create()
                    :move(display.center)
                    :addTo(self)
    local _node = cc.DrawNode:create()
    --stencil:setDrawColor4B(green)
    _node:drawSolidRect(cc.p(-self.halfWalkHeight * 3, -self.halfWalkHeight * 3),
                 cc.p(self.halfWalkHeight * 3, Const.wallHeight * 2.5), cc.c4f(0, 0, 0, 1))
    self.mapCenter:setStencil(_node)

    self.mapConfig = config
    self.mapLayer = Wall:new()
    self.mapLayer:init(self)
    self.mapLayer:addTo(self.mapCenter)
    -- local _startPoint = self.mapConfig.start
    -- self.startPoint = cc.p(_startPoint.x * Const.wallHeight, _startPoint.y * Const.wallHeight)
    -- self:createAheadMap(_startPoint.x, _startPoint.y)
    -- self:createMap(self.mapConfig)


    local role = Role:new()
    role:init(self)
    role:setScale(2)
    role:move(display.cx, display.cy - Const.wallHeight)
    role:addTo(self)
    role:idle(3)
    self.role = role
    role:startMove()
end

function MapScene:greyLBtn(enable)
    local _opacity = enable and 255 or 100
    self.leftBtn:setOpacity(_opacity)
    self.leftBtn:setTouchEnabled(enable)
end
function MapScene:greyRBtn(enable)
    local _opacity = enable and 255 or 100
    self.rightBtn:setOpacity(_opacity)
    self.rightBtn:setTouchEnabled(enable)
end
function MapScene:greyUBtn(enable)
    local _opacity = enable and 255 or 100
    self.upBtn:setOpacity(_opacity)
    self.upBtn:setTouchEnabled(enable)
end
function MapScene:greyDBtn(enable)
    self.upBtn:setVisible(not enable)
    self.leftBtn:setVisible(not enable)
    self.rightBtn:setVisible(not enable)
    self.downBtn:setVisible(enable)
    self.downBtn:setTouchEnabled(enable)
end
function MapScene:showWarn()
    local _index, _text, _name, _text1
    local _layer = display.newNode()
        :move(display.cx, display.cy + 200)
        :addTo(self)
    local _config = Utils.getAllConfig("DictumConfig")
    _index = math.random(1, #_config)
    _text = _config[_index].text
    _text1 = _config[_index].text1
    _name = _config[_index].name
    if not self.text then
        self.text = cc.Label:createWithTTF("", "simsun.ttf", 40)
            :setTextColor(display.COLOR_BLACK)
            :enableOutline(cc.c4b(255,255,255,255),1)
            :addTo(_layer)
            :setString(_text)
    else
        self.text:setVisible(true)
        self.text:setString(_text)
    end
    if not self.text1 then
        self.text1 = cc.Label:createWithTTF("", "simsun.ttf", 40)
            :setTextColor(display.COLOR_BLACK)
            :enableOutline(cc.c4b(255,255,255,255),1)
            :move(0, -45)
            :addTo(_layer)
            :setString(_text1)
    else
        _text1 = _text1 or ""
        self.text1:setVisible(true)
        self.text1:setString(_text1)
    end
    if not self.name then
        self.name = cc.Label:createWithTTF("", "simsun.ttf", 40)
            :setTextColor(display.COLOR_BLACK)
            :enableOutline(cc.c4b(255,255,255,255),1)
            :addTo(_layer)
            :move(100, -100)
            :setString("——".._name)
    else
        self.name:setVisible(true)
        self.name:setString("——".._name)
    end
end
function MapScene:hideWarn()
    self.name:setVisible(false)
    self.text:setVisible(false)
    self.text1:setVisible(false)
end
function MapScene:newExitLayer()
    local _layer = display.newLayer(cc.c4b(255,255,255,255))
        :setContentSize(400, 300)
        :move(display.cx - 200, display.cy)
        :addTo(self, 100)

    cc.Label:createWithSystemFont("发起挑战吗？", "Arial", 40)
                :setTextColor(display.COLOR_BLACK)
                :move(200, 200)
                :addTo(_layer)

    local _btn = ccui.Button:create("mgd_30.png")
                    :setScale(-0.7, 0.7)
                    :move(100, 40)
                    :addTo(_layer)
    _btn:addTouchEventListener(function (sender, event)
        if event == ccui.TouchEventType.ended then
            local map = self:getApp():createView("MainScene")
            map:showWithScene()
        end
    end)
    local _size = _btn:getContentSize()
    cc.Label:createWithSystemFont("放弃", "Arial", 40)
                :setScaleX(-1)
                :setTextColor(display.COLOR_BLACK)
                :move(_size.width / 2 - 20, _size.height)
                :addTo(_btn)

    _btn = ccui.Button:create("mgd_30.png")
                :setScale(0.7)
                :move(300, 40)
                :addTo(_layer)
    _btn:addTouchEventListener(function (sender, event)
        if event == ccui.TouchEventType.ended then
            _layer:removeFromParent()
        end
    end)
    cc.Label:createWithSystemFont("继续", "Arial", 40)
                :setTextColor(display.COLOR_BLACK)
                :move(_size.width / 2 - 20, _size.height)
                :addTo(_btn)
end
function MapScene:loadMap()
    local path = "map.lua"
    return require(path)
end
return MapScene