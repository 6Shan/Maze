local ReadyScene = class("ReadyScene", cc.load("mvc").ViewBase)

function ReadyScene:onCreate()
    self.btnList = {}
    cc.LayerColor:create(cc.c4b(0, 255, 255, 155))
        :addTo(self)

    self.leftBtn = ccui.Button:create("mgd_30.png")
                    :setScale(-0.7, 0.7)
                    :move(display.cx - 180, display.bottom + 60)
                    :addTo(self)
                    :setTag(Const.left)
    self.leftBtn:addTouchEventListener(function (sender, event)
            if event == ccui.TouchEventType.ended then
                local map = self:getApp():createView("LevelScene")
                map:showWithScene()
            end
        end)
    local _size = self.leftBtn:getContentSize()
    cc.Label:createWithSystemFont("返回", "Arial", 30)
                :setScaleX(-1)
                :move(_size.width / 2 - 20, _size.height)
                :setColor(cc.c3b(0,0,0))
                :addTo(self.leftBtn)
    
    self.rightBtn = ccui.Button:create("mgd_30.png")
                    :setScale(0.7)
                    :move(display.cx + 180, display.bottom + 60)
                    :addTo(self)
                    :setTag(Const.right)
    self.rightBtn:addTouchEventListener(function (sender, event)
            if event == ccui.TouchEventType.ended then
                local map = self:getApp():createView("MapScene")
                map:init(self.config)
                map:showWithScene()
            end
        end)
    cc.Label:createWithSystemFont("挑战", "Arial", 30)
            :move(_size.width / 2 - 20, _size.height)
            :setColor(cc.c3b(0,0,0))
            :addTo(self.rightBtn)


end
function ReadyScene:init(mapID)
    self.config = self:loadMap(mapID)
    local _config = Utils.getAllConfig("StroyConfig")
    
    local _layer = display.newLayer(cc.c4b(255,255,255,255))
            :move(display.cx - 200, display.top - 150)
            :setContentSize(400, 100)
            :addTo(self)

    cc.Label:createWithSystemFont(_config[mapID].title, "Arial", 30)
        :setTextColor(display.COLOR_BLACK)
        :move(200, 75)
        :addTo(_layer)
    cc.Label:createWithSystemFont(_config[mapID].tip, "Arial", 30)
        :setTextColor(display.COLOR_BLACK)
        :move(200, 30)
        :addTo(_layer)

    local _text, _text1, _name
    _text = _config[mapID].text
    _text1 = _config[mapID].text1
    _name = _config[mapID].name
    cc.Label:createWithTTF("", "simsun.ttf", 28)
        :move(display.cx, 190)
        :setTextColor(display.COLOR_BLACK)
        -- :enableOutline(cc.c4b(255,255,255,255),1)
        :addTo(self)
        :setString(_text)
    cc.Label:createWithTTF("", "simsun.ttf", 28)
        :setTextColor(display.COLOR_BLACK)
        -- :enableOutline(cc.c4b(255,255,255,255),1)
        :move(display.cx, 165)
        :addTo(self)
        :setString(_text1)
    cc.Label:createWithTTF("", "simsun.ttf", 28)
        :setTextColor(display.COLOR_BLACK)
        -- :enableOutline(cc.c4b(255,255,255,255),1)
        :addTo(self)
        :move(display.cx + 180, 130)
        :setString("——".._name)
    if _config[mapID].type == 4 then
        display.newSprite("mgd_01.png")
            :move(display.center)
            :addTo(self)
        return
    end

    self.pointHeight = height or 54
    self.editHeight = editHeight or 530
    self.mapHeight = mapHeight or 1350
    self.minScale = self.editHeight / self.mapHeight
    self.maxScale = 1
    self.pointHeightHalf = self.pointHeight / 2
    local _editSize = cc.size(self.editHeight, self.editHeight)
    local _mapHeight = cc.size(self.mapHeight, self.mapHeight)
    self.editMap = ccui.ScrollView:create()
            :setAnchorPoint(cc.p(0.5, 0.5))
            :move(display.center)
            :setContentSize(_editSize)
            :setInnerContainerSize(_mapHeight)
            :setDirection(cc.SCROLLVIEW_DIRECTION_HORIZONTAL)
            :addTo(self)
            :setTouchEnabled(false)
            :setScrollBarEnabled(false)

    local _node = display.newLayer()
                :addTo(self.editMap)

    self.mapLayer = cc.LayerColor:create(cc.c4b(255, 255, 255, 255))
                    :move(0, 0)
                    :setScale(self.minScale)
                    :setAnchorPoint(cc.p(0, 0))
                    :setContentSize(_mapHeight)
                    :addTo(_node)
    self.editMap:setInnerContainerSize(cc.size(self.mapHeight * self.minScale, self.mapHeight * self.minScale))

    self.lineNode = cc.DrawNode:create()
                    :addTo(self.mapLayer)

    local _total = self.mapHeight / self.pointHeight
    self:changeMaze(_total, _config[mapID].type)
    self.mapArray = {}
    for i=1,_total do
        self.mapArray[i]={}
        for j=1,_total do
            self.mapArray[i][j] = 0
        end
        self.lineNode:drawLine(cc.p(0, self.pointHeight * i), cc.p(1350, self.pointHeight * i), cc.c4f(0, 0, 0, 0.5))
    end

    for i=0,_total do
        self.lineNode:drawLine(cc.p(self.pointHeight * i, 0), cc.p(self.pointHeight * i, 1350), cc.c4f(0, 0, 0, 0.5))
    end

end

function ReadyScene:loadMap(mapID)
    local path = "config/map/"..mapID
    return require(path)
end

function ReadyScene:changeMaze(total, mapType)
 
    for i=1,total do
        for j=1,total do
            local _state = self.config[i][j]
            local _x = self.pointHeight * i
            local _y = self.pointHeight * j

            if _state == Const.start and mapType ~= 2 then
                    self.lineNode:drawSolidRect(cc.p(_x, _y),
                         cc.p(_x + self.pointHeight, _y + self.pointHeight), cc.c4f(0, 1, 0, 1))
            elseif _state == Const.ended and mapType ~= 3 then
                    self.lineNode:drawSolidRect(cc.p(_x, _y),
                         cc.p(_x + self.pointHeight, _y + self.pointHeight), cc.c4f(1, 0, 0, 1))
            elseif _state == Const.road then
                self.lineNode:drawSolidRect(cc.p(_x, _y),
                         cc.p(_x + self.pointHeight, _y + self.pointHeight), cc.c4f(0, 0, 0, 1))
            end
        end
    end

end


return ReadyScene