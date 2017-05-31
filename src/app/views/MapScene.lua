
local MapScene = class("MapScene", cc.load("mvc").ViewBase)

local Role = require "app.module.Role"
local ClickLayer = require "app.views.ClickLayer"

function MapScene:onCreate()
    -- -- add background image
    -- display.newSprite("HelloWorld.png")
    --     :move(display.center)
    --     :addTo(self)

    -- add HelloWorld label
    -- local label = cc.Label:createWithSystemFont("Hello World", "Arial", 40)
    -- label:move(display.cx, display.cy)
    -- label:addTo(self)

    -- local button = ccui.Button:create("mgd_19.png")
    -- button:move(display.cx, display.cy - 200)
    -- button:addTo(self)
    -- button:addTouchEventListener(function ()
    	
    -- end)
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
    
    -- local role = Role:new()
    -- role:init()
    -- role:move(display.cx, display.cy)
    -- role:addTo(self)
    -- role:idle(0)
    
    -- local role = Role:new()
    -- role:init()
    -- role:move(display.cx - 100, display.cy)
    -- role:addTo(self)
    -- role:idle(1)
    
    -- local role = Role:new()
    -- role:init()
    -- role:move(display.cx + 100, display.cy)
    -- role:addTo(self)
    -- role:idle(2)
    

    -- local walk = 
    self.upBtn = ccui.Button:create("mgd_29.png")
                    :setScale(0.5, 0.7)
                    :move(display.cx, display.bottom + 180)
                    :addTo(self)
                    :setZoomScale(0)
                    :setTag(Const.up)
    self.btnList[Const.up] = self.upBtn
    
    self.downBtn = ccui.Button:create("mgd_29.png")
                    :setScale(0.5, -0.7)
                    :move(display.cx, display.bottom + 20)
                    :addTo(self)
                    :setZoomScale(0)
                    :setTag(Const.down)
    self.btnList[Const.down] = self.downBtn

    self.leftBtn = ccui.Button:create("mgd_30.png")
                    :setScale(-0.5, 0.5)
                    :move(display.cx - 120, display.bottom + 80)
                    :addTo(self)
                    :setZoomScale(0)
                    :setTag(Const.left)
    self.btnList[Const.left] = self.leftBtn
    
    self.rightBtn = ccui.Button:create("mgd_30.png")
                    :setScale(0.5)
                    :move(display.cx + 120, display.bottom + 80)
                    :addTo(self)
                    :setZoomScale(0)
                    :setTag(Const.right)
    self.btnList[Const.right] = self.rightBtn

    -- Utils.printTable(Utils.unserialize(self:loadMap()))
    -- local role = cc.Sprite:create("mgd_28.png")
    -- cc.Sprite:create("mgd_28.png")
    self.mapConfig = Utils.unserialize(self:loadMap())
    self:creaeMap(self.mapConfig)

    local role = Role:new()
    role:init(self)
    role:setScale(2)
    role:move(self.startPoint)
    role:addTo(self.mapLayer)
    role:idle(3)
    self.role = role
    self.clickLayer = ClickLayer:new()
    self.clickLayer:init(self.btnList, self)
    self.clickLayer:addTo(self)

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

function MapScene:creaeMap(config)
    self.mapLayer = display.newLayer()
                    :addTo(self)
                    :move(0,0)
    for x,tbl in ipairs(config) do
        for y,v in ipairs(tbl) do
            if v ~= 0 then
                if not tbl[y+1] then
                    self:addUpWall(x, y)
                elseif tbl[y+1] == 0 then
                    self:addUpWall(x, y)
                end
                if not tbl[y-1] then
                    self:addDownWall(x, y)
                elseif tbl[y-1] == 0 then
                    self:addDownWall(x, y)
                end
                if not config[x-1] then
                    self:addLeftWall(x, y)
                elseif config[x-1][y] == 0 then
                    self:addLeftWall(x, y)
                end
                if not config[x+1] then
                    self:addRightWall(x, y)
                elseif config[x+1][y] == 0 then
                    self:addRightWall(x, y)
                end
                if v == Const.start then
                    self.startPoint = cc.p(x * Const.roleHeight, y * Const.roleHeight)
                elseif v == Const.ended then
                    self.endPoint = cc.p(x * Const.roleHeight, y * Const.roleHeight)
                end
            end
        end
    end
end

function MapScene:addUpWall(x, y)
    print("00000000addUpWall")
    local _x = x * Const.roleHeight
    local _y = y * Const.roleHeight
    display.newSprite("mgd_27.png")
        :move(_x, _y + Const.roleHeight)
        :setScale(-1)
        :addTo(self.mapLayer)
end
function MapScene:addDownWall(x, y)
    print("00000000addDownWall")
    local _x = x * Const.roleHeight
    local _y = y * Const.roleHeight
    display.newSprite("mgd_27.png")
        :move(_x, _y - Const.roleHeight)
        :setScale(1)
        :addTo(self.mapLayer)
end
function MapScene:addLeftWall(x, y)
    print("00000000addLeftWall")
    local _x = x * Const.roleHeight
    local _y = y * Const.roleHeight
    display.newSprite("mgd_07.png")
        :move(_x - Const.roleHeight, _y)
        :setScale(-1)
        :addTo(self.mapLayer)
end
function MapScene:addRightWall(x, y)
    print("00000000addRightWall")
    local _x = x * Const.roleHeight
    local _y = y * Const.roleHeight
    display.newSprite("mgd_07.png")
        :move(_x + Const.roleHeight, _y)
        :setScale(1)
        :addTo(self.mapLayer)
end
function MapScene:onTouchBtn(touch, event)
    if event == ccui.TouchEventType.began then
        local _scaleX, _scaleY = touch:getScaleX(), touch:getScaleY()
        touch:setScale(_scaleX * 1.1, _scaleY * 1.1)
        touch.preScaleX = _scaleX
        touch.preScaleY = _scaleY
        self.role:walkTo(touch:getTag())
        self.pressBtn = touch
        -- touch:setScale(touch:getScaleX() * 1.1, touch:getScaleY() * 1.1)
        -- return true
    -- elseif event == ccui.TouchEventType.moved then
    --     Utils.printTable(touch:getTouchMovePosition())
    elseif event == ccui.TouchEventType.ended or event == ccui.TouchEventType.canceled then
        touch:setScale(touch.preScaleX, touch.preScaleY)
        if self.role.moveFail then
            self.role.moveFail = nil
            self.role:idle(touch:getTag())
        end
        self.pressBtn = nil
    end
end
function MapScene:checkMove(posX, posY)
    local _x = posX / Const.roleHeight
    local _y = posY / Const.roleHeight
    if self.mapConfig[_x] and self.mapConfig[_x][_y] then 
        if self.mapConfig[_x][_y] == 0 then
            self.role.moveFail = true
            return false
        end
        return true
    end
    self.role.moveFail = true
    return false
end
function MapScene:checkEnd(posX, posY)
    print(posX, posY, self.endPoint.x, self.endPoint.y)
    if posX == self.endPoint.x and posY == self.endPoint.y then
        local _layer = display.newLayer(cc.c4b(0,0,0,255))
            :setContentSize(400, 100)
            :move(display.cx - 200, display.cy + 200)
            :addTo(self)
        cc.Label:createWithSystemFont("Game clearance", "Arial", 40)
            :move(200,50)
            :addTo(_layer)
    end
end
return MapScene
