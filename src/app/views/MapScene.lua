
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
    
    local role = Role:new()
    role:init()
    role:move(display.cx, display.cy)
    role:addTo(self)
    role:walkTo(0)
    
    local role = Role:new()
    role:init()
    role:move(display.cx - 100, display.cy)
    role:addTo(self)
    role:walkTo(1)
    
    local role = Role:new()
    role:init()
    role:move(display.cx + 100, display.cy)
    role:addTo(self)
    role:walkTo(2)
    
    local role = Role:new()
    role:init()
    role:move(display.cx, display.cy + 100)
    role:addTo(self)
    role:walkTo(3)
    
    

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
    
end
function MapScene:addDownWall(x, y)
    
end
function MapScene:addLeftWall(x, y)
    
end
function MapScene:addRightWall(x, y)
    
end

return MapScene
