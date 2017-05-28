
local MapScene = class("MapScene", cc.load("mvc").ViewBase)

local Role = require "app.module.Role"

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
    -- role:walkTo(0)
    
    -- local role = Role:new()
    -- role:init()
    -- role:move(display.cx - 100, display.cy)
    -- role:addTo(self)
    -- role:walkTo(1)
    
    -- local role = Role:new()
    -- role:init()
    -- role:move(display.cx + 100, display.cy)
    -- role:addTo(self)
    -- role:walkTo(2)
    
    local role = Role:new()
    role:init()
    role:setScale(2)
    role:move(display.cx, display.cy)
    role:addTo(self)
    role:walkTo(3)

    -- local walk = 
    self.upBtn = ccui.Button:create("mgd_29.png")
                    :setScale(0.5, 0.7)
                    :move(display.cx, display.bottom + 180)
                    :addTo(self)
    self.upBtn:addTouchEventListener(function (sender, event) 
        if event == ccui.TouchEventType.began then
            self.editMap:setTouchEnabled(false)
        end
    end)
    
    self.downBtn = ccui.Button:create("mgd_29.png")
                    :setScale(0.5, -0.7)
                    :move(display.cx, display.bottom + 20)
                    :addTo(self)
    self.downBtn:addTouchEventListener(function (sender, event) 
        if event == ccui.TouchEventType.began then
            self.editMap:setTouchEnabled(false)
        end
    end)
    
    self.leftBtn = ccui.Button:create("mgd_30.png")
                    :setScale(-0.5, 0.5)
                    :move(display.cx - 120, display.bottom + 80)
                    :addTo(self)
    self.leftBtn:addTouchEventListener(function (sender, event) 
        if event == ccui.TouchEventType.began then
            self.editMap:setTouchEnabled(true)
        end
    end)
    
    self.rightBtn = ccui.Button:create("mgd_30.png")
                    :setScale(0.5)
                    :move(display.cx + 120, display.bottom + 80)
                    :addTo(self)
    self.rightBtn:addTouchEventListener(function (sender, event) 
        if event == ccui.TouchEventType.began then
            self.editMap:setTouchEnabled(false)
        end
    end)

    Utils.printTable(Utils.unserialize(self:loadMap()))
    -- local role = cc.Sprite:create("mgd_28.png")
    -- cc.Sprite:create("mgd_28.png")
    self.mapConfig = Utils.unserialize(self:loadMap())
    self:creaeMap(self.mapConfig)
end

function MapScene:loadMap()
    local fileUtil = cc.FileUtils:getInstance()
    local path = fileUtil:getWritablePath().."222.json"
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
                    :setScale(0.6)
    for x,tbl in pairs(config) do
        for y,v in ipairs(tbl) do
            if v ~= 0 then
                if not tbl[y-1] then
                    self:addUpWall(x, y)
                elseif tbl[y-1] == 0 then
                    self:addUpWall(x, y)
                end
                if not tbl[y+1] then
                    self:addDownWall(x, y)
                elseif tbl[y+1] == 0 then
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
        :setScale(0.5, 0.5)
        :addTo(self.mapLayer)
end
function MapScene:addDownWall(x, y)
    print("00000000addDownWall")
    local _x = x * Const.roleHeight
    local _y = y * Const.roleHeight
    display.newSprite("mgd_27.png")
        :move(_x, _y - Const.roleHeight)
        :setScale(0.5, -0.5)
        :addTo(self.mapLayer)
end
function MapScene:addLeftWall(x, y)
    print("00000000addLeftWall")
    local _x = x * Const.roleHeight
    local _y = y * Const.roleHeight
    display.newSprite("mgd_07.png")
        :move(_x - Const.roleHeight, _y)
        :setScale(-0.5, 0.5)
        :addTo(self.mapLayer)
end
function MapScene:addRightWall(x, y)
    print("00000000addRightWall")
    local _x = x * Const.roleHeight
    local _y = y * Const.roleHeight
    display.newSprite("mgd_07.png")
        :move(_x + Const.roleHeight, _y)
        :setScale(0.5)
        :addTo(self.mapLayer)
end

return MapScene
