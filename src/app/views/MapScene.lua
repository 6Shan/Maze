local MapScene = class("MapScene", cc.load("mvc").ViewBase)

local Role = require "app.module.Role"
local Wall = require "app.module.Wall"

function MapScene:onCreate()
    self.btnList = {}
    cc.LayerColor:create(cc.c4b(255, 255, 255, 255))
        :move(display.left, display.bottom)
        :setContentSize(cc.size(640, 960))
        :addTo(self)
    self.giveup = cc.Label:createWithSystemFont("放弃", "Arial", 24)
                :move(display.cx - 120, display.top - 50)
                :addTo(self)

    ccui.Button:create("mgd_30.png")
        :setScale(-0.5)
        :move(10, -12)
        :addTo(self.giveup)
        :addTouchEventListener(function (sender, event) 
            local map = self:getApp():createView("MainScene")
            map:showWithScene()
        end)
    
    self.upBtn = ccui.Button:create("mgd_29.png")
                    :setScale(1)
                    :move(display.cx, display.bottom + 150)
                    :addTo(self)
                    :setZoomScale(0)
                    :setTag(Const.up)
    self.upBtn:addTouchEventListener(function (sender, event)
            if event == ccui.TouchEventType.ended then
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
                self.mapLayer:turn(Const.right)
            end
        end)
    self.btnList[Const.right] = self.rightBtn
    cc.Label:createWithSystemFont("向右走", "Arial", 30)
            :move(_size.width / 2 - 20, _size.height)
            :setColor(cc.c3b(0,0,0))
            :addTo(self.rightBtn)

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


    self.mapConfig = Utils.unserialize(self:loadMap())
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

    -- self:greyLBtn()
end
function MapScene:loadMap()
    local fileUtil = cc.FileUtils:getInstance()
    local path = fileUtil:getWritablePath().."map.lua"
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
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
return MapScene