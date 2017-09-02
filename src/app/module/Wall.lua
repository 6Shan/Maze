local Wall = class("Wall", cc.Layer)

function Wall:init(parent)

    -- self.direction = Const.up

    self.mapData = {}
    self.halfWalkHeight = Const.wallHeight / 2
	self.parent = parent
	self.config = parent.mapConfig
    self.showPoint = {}
    self.showPointLen = 0
	self:createMap(self.config)
    -- self:checkShowPoint(self.startPoint.x, self.startPoint.y + 1)
    self.mapXLen = #self.mapData
    self.mapYLen = #self.mapData[1]
    if self.mapXLen > self.mapYLen then

    end
    self.mapWidth = self.mapXLen * Const.wallHeight
    self.mapHeight = self.mapYLen * Const.wallHeight
    print(self.mapWidth, self.mapHeight, "sldflsdlfl")
    self:setContentSize(cc.size(self.mapWidth, self.mapHeight))
    self.mapScale = 1 / self.mapXLen
    self:checkStart()

    -- self:addTouch()
end

function Wall:createMap(config)
    for x,tbl in ipairs(config) do
        self.mapData[x] = {}
        for y,v in ipairs(tbl) do
            self.mapData[x][y] = {}
            if v ~= 0 then
            	self.mapData[x][y].nodeList = {}
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
                    self.startPoint = cc.p(x, y)
                    local _sprite = display.newSprite("mgd_10.png")
                        :move(x * Const.wallHeight, y * Const.wallHeight)
                        :setScale(0.9)
                        :addTo(self, -1)
                        :setVisible(false)
                    table.insert(self.mapData[x][y].nodeList, _sprite)
                    self:move(-x * Const.wallHeight, -y * Const.wallHeight - Const.wallHeight)
                elseif v == Const.ended then
                    self.endPoint = cc.p(x, y)
                    local _sprite = display.newSprite("mgd_08.png")
                        :move(x * Const.wallHeight, y * Const.wallHeight)
                        :setScale(0.9)
                        :addTo(self, -1)
                        :setVisible(false)
                    table.insert(self.mapData[x][y].nodeList, _sprite)
                end
            end
        end
    end
end

function Wall:addUpWall(x, y)
    local _x = x * Const.wallHeight
    local _y = y * Const.wallHeight
    local _sprite = display.newSprite("mgd_27.png")
        :move(_x, _y + self.halfWalkHeight)
        :setAnchorPoint(0.5, 1)
        :setScale(-1)
        :addTo(self)
        :setVisible(false)
    table.insert(self.mapData[x][y].nodeList, _sprite)
end

function Wall:addDownWall(x, y)
    local _x = x * Const.wallHeight
    local _y = y * Const.wallHeight
    local _sprite = display.newSprite("mgd_27.png")
        :move(_x, _y - self.halfWalkHeight)
        :setAnchorPoint(0.5, 1)
        :setScale(1)
        :addTo(self)
        :setVisible(false)
    table.insert(self.mapData[x][y].nodeList, _sprite)
end

function Wall:addLeftWall(x, y)
    local _x = x * Const.wallHeight
    local _y = y * Const.wallHeight
    local _sprite = display.newSprite("mgd_07.png")
        :move(_x - self.halfWalkHeight, _y)
        :setAnchorPoint(0, 0.5)
        :setScale(-1)
        :addTo(self)
        :setVisible(false)
    table.insert(self.mapData[x][y].nodeList, _sprite)
end

function Wall:addRightWall(x, y)
    local _x = x * Const.wallHeight
    local _y = y * Const.wallHeight
    local _sprite = display.newSprite("mgd_07.png")
        :move(_x + self.halfWalkHeight, _y)
        :setAnchorPoint(0, 0.5)
        :setScale(1)
        :addTo(self)
        :setVisible(false)
    table.insert(self.mapData[x][y].nodeList, _sprite)
end

function Wall:checkEnd(posX, posY)
    if posX == self.endPoint.x and posY == self.endPoint.y then
    	return true
    end
end

function Wall:checkShowPoint(x, y)
	self.idleX = x
    self.idleY = y
    local _x, _y
    self:hide(x,y)
    self.showPoint = {}
	if self.direction == Const.up then
		if self:checkNum(x, y+1) then
			_y = y - 2
			for i=1,3 do
				_x = x - 2
				for j=1,3 do
					if self:checkNum(_x+j, _y+i) then
                        table.insert(self.showPoint, {_x+j, _y+i})
					end
				end
			end
            _x = x - 2
            for i=1,3 do
                if self:checkNum(_x+i, y+2) then
                    if self:checkNum(_x+i, y+1) or 
                        self:checkNum(x, y+2) then
                        table.insert(self.showPoint, {_x+i, y+2})
                    end
                end
            end
		else
            table.insert(self.showPoint, {x, y})
			_x = x - 2
			for i=1,3 do
				if self:checkNum(_x+i, y-1) then
                    table.insert(self.showPoint, {_x+i, y-1})
				end
			end
		end
	elseif self.direction == Const.down then
        if self:checkNum(x, y-1) then
            _y = y - 2
            for i=1,3 do
                _x = x - 2
                for j=1,3 do
                    if self:checkNum(_x+j, _y+i) then
                        table.insert(self.showPoint, {_x+j, _y+i})
                    end
                end
            end
            _x = x - 2
            for i=1,3 do
                if self:checkNum(_x+i, y-2) then
                    if self:checkNum(_x+i, y-1) or 
                        self:checkNum(x, y-2) then
                        table.insert(self.showPoint, {_x+i, y-2})
                    end
                end
            end
        else
            table.insert(self.showPoint, {x, y})
            _x = x - 2
            for j=1,2 do
                for i=1,3 do
                    if self:checkNum(_x+i, y+1) then
                        table.insert(self.showPoint, {_x+i, y+1})
                    end
                end
            end
        end
	elseif self.direction == Const.left then
        if self:checkNum(x-1, y) then
            _x = x - 2
            for i=1,3 do
                _y = y - 2
                for j=1,3 do
                    if self:checkNum(_x+i, _y+j) then
                        table.insert(self.showPoint, {_x+i, _y+j})
                    end
                end
            end
            _y = y - 2
            for i=1,3 do
                if self:checkNum(x-2, _y+i) then
                    if self:checkNum(x-1, _y+i) or
                        self:checkNum(x-2, y) then
                        table.insert(self.showPoint, {x-2, _y+i})
                    end
                end
            end
        else
            table.insert(self.showPoint, {x, y})
            _y = y - 2
            for i=1,3 do
                if self:checkNum(x-1, _y+i) then
                    table.insert(self.showPoint, {x-1, _y+i})
                end
            end
        end
	elseif self.direction == Const.right then
        if self:checkNum(x+1, y) then
            _x = x - 2
            for i=1,3 do
                _y = y - 2
                for j=1,3 do
                    if self:checkNum(_x+i, _y+j) then
                        table.insert(self.showPoint, {_x+i, _y+j})
                    end
                end
            end
            _y = y - 2
            for i=1,3 do
                if self:checkNum(x+2, _y+i) then
                    if self:checkNum(x+1, _y+i) or
                        self:checkNum(x+2, y) then
                        table.insert(self.showPoint, {x+2, _y+i})
                    end
                end
            end
        else
            table.insert(self.showPoint, {x, y})
            _y = y - 2
            for i=1,3 do
                if self:checkNum(x+1, _y+i) then
                    table.insert(self.showPoint, {x+1, _y+i})
                end
            end
        end
	end
    for _,v in pairs(self.showPoint) do
        for _,node in pairs(self.mapData[v[1]][v[2]].nodeList) do
            node:setOpacity(255)
            node:setVisible(true)
        end
    end
end

function Wall:hide(x, y)
	if self.direction == Const.up then
        for k,v in pairs(self.showPoint) do
            if (v[1] < x-1 or v[1] > x+1) or (v[2] < y-1 or v[2] > y+2) then
                for _,node in pairs(self.mapData[v[1]][v[2]].nodeList) do
                    -- node:setVisible(false)
                    node:runAction(cc.FadeOut:create(Const.speed))
                end
            end
        end
    elseif self.direction == Const.down then
        for k,v in pairs(self.showPoint) do
            if (v[1] < x-1 or v[1] > x+1) or (v[2] < y-2 or v[2] > y+1) then
                for _,node in pairs(self.mapData[v[1]][v[2]].nodeList) do
                    -- node:setVisible(false)
                    node:runAction(cc.FadeOut:create(Const.speed))
                end
            end
        end
    elseif self.direction == Const.left then
        for k,v in pairs(self.showPoint) do
            if (v[1] < x-2 or v[1] > x+1) or (v[2] < y-1 or v[2] > y+1) then
                for _,node in pairs(self.mapData[v[1]][v[2]].nodeList) do
                    -- node:setVisible(false)
                    node:runAction(cc.FadeOut:create(Const.speed))
                end
            end
        end
    elseif self.direction == Const.right then
        for k,v in pairs(self.showPoint) do
            if (v[1] < x-1 or v[1] > x+2) or (v[2] < y-1 or v[2] > y+1) then
                for _,node in pairs(self.mapData[v[1]][v[2]].nodeList) do
                    -- node:setVisible(false)
                    node:runAction(cc.FadeOut:create(Const.speed))
                end
            end
        end
    end
end

function Wall:turn(direction)
    if self.moving then
        return
    end
    self.moving = true
    print("Wall:turn", direction, self.direction)
    self.parent.role:walkTo()
    local _nextDir, _rotate
    if direction == Const.left then
        _nextDir = (self.direction + 4 - 1) % 4
    else
        _nextDir = (self.direction + 1) % 4
    end
    if self.pirouette then
        self.pirouette = nil
        self:changeAnchorPoint()
        if direction == Const.left then
            _rotate = cc.RotateBy:create(Const.roSpeed, 90)
        else
            _rotate = cc.RotateBy:create(Const.roSpeed, -90)
        end
        self.direction = _nextDir
        local _call = cc.CallFunc:create(function ()
            self:checkMove()
        end)
        local _seq = cc.Sequence:create(_rotate, _call)
    
        self:runAction(_seq)
        return
    end
    local _situation
    if self.direction == Const.up then
        _situation = self:checkAround(self.idleX, self.idleY + 1, _nextDir)
    elseif self.direction == Const.down then
        _situation = self:checkAround(self.idleX, self.idleY - 1, _nextDir)
    elseif self.direction == Const.left then
        _situation = self:checkAround(self.idleX - 1, self.idleY, _nextDir)
    elseif self.direction == Const.right then
        _situation = self:checkAround(self.idleX + 1, self.idleY, _nextDir)
    end
    local _stop = nil
    if _situation ~= Const.noRoad and 
        _situation ~= Const.uRoad then
        _stop = true
    end
    if direction == Const.left then
        if self.direction == Const.up then
            self.direction = Const.left
            self:checkShowPoint(self.idleX, self.idleY + 1)
        elseif self.direction == Const.left then
            self.direction = Const.down
            self:checkShowPoint(self.idleX - 1, self.idleY)
        elseif self.direction == Const.down then
            self.direction = Const.right
            self:checkShowPoint(self.idleX, self.idleY - 1)
        elseif self.direction == Const.right then
            self.direction = Const.up
            self:checkShowPoint(self.idleX + 1, self.idleY)
        end
        _rotate = cc.RotateBy:create(Const.roSpeed, 90)
    else
        if self.direction == Const.up then
            self.direction = Const.right
            self:checkShowPoint(self.idleX, self.idleY + 1)
        elseif self.direction == Const.left then
            self.direction = Const.up
            self:checkShowPoint(self.idleX - 1, self.idleY)
        elseif self.direction == Const.down then
            self.direction = Const.left
            self:checkShowPoint(self.idleX, self.idleY - 1)
        elseif self.direction == Const.right then
            self.direction = Const.down
            self:checkShowPoint(self.idleX + 1, self.idleY)
        end
        _rotate = cc.RotateBy:create(Const.roSpeed, -90)
    end
    local _move = cc.MoveBy:create(Const.speed, cc.p(0, -Const.wallHeight))
    local _delay = cc.DelayTime:create(0.3)
    local _call1 = cc.CallFunc:create(function ()
        self:changeAnchorPoint()
    end)
    -- local _spawn = cc.Spawn:create(_bezier, _rotate)
    local _call = cc.CallFunc:create(function ()
        if _stop then
            self:checkMove()
        else
            if self.direction == Const.up then
                self:checkShowPoint(self.idleX, self.idleY + 1)
            elseif self.direction == Const.left then
                self:checkShowPoint(self.idleX - 1, self.idleY)
            elseif self.direction == Const.down then
                self:checkShowPoint(self.idleX, self.idleY - 1)
            elseif self.direction == Const.right then
                self:checkShowPoint(self.idleX + 1, self.idleY)
            end
            self:runAction(cc.Sequence:create(_move, cc.CallFunc:create(function ()
                self:checkMove()
            end)))
        end
    end)
    local _seq = cc.Sequence:create(_move, _call1, _delay, _rotate, _call)
    self:runAction(_seq)
end

function Wall:goAhead()
    if self.moving then
        return
    end
    self.moving = true
    if self.direction == Const.up then
        self:checkShowPoint(self.idleX, self.idleY + 1)
    elseif self.direction == Const.down then
        self:checkShowPoint(self.idleX, self.idleY - 1)
    elseif self.direction == Const.left then
        self:checkShowPoint(self.idleX - 1, self.idleY)
    elseif self.direction == Const.right then
        self:checkShowPoint(self.idleX + 1, self.idleY)
    end
    self.parent.role:walkTo()
    local _move = cc.MoveBy:create(Const.speed, cc.p(0, -Const.wallHeight))
    local _call = cc.CallFunc:create(function ()
        self:checkMove()
    end)
    local _seq = cc.Sequence:create(_move, _call)
    self:runAction(_seq)
end
function Wall:reverse()
    if self.moving then
        return
    end
    self.moving = true
    if self.direction == Const.up then
        self.direction = Const.down
    elseif self.direction == Const.down then
        self.direction = Const.up
    elseif self.direction == Const.left then
        self.direction = Const.right
    elseif self.direction == Const.right then
        self.direction = Const.left
    end
    self:changeAnchorPoint()
    local _rotate = cc.RotateBy:create(Const.roSpeed, 180)
    local _call = cc.CallFunc:create(function ()
        self:checkMove()
    end)
    local _seq = cc.Sequence:create(_rotate, _call)
    self:runAction(_seq)
end
function Wall:changeAnchorPoint()
    self:setAnchorPoint(self.idleX*self.mapScale , self.idleY*self.mapScale)
    self:setPosition(self.idleX*-Const.wallHeight, self.idleY*-Const.wallHeight)
end

-- function Wall:setAnchorPoint(x, y)
--     local _aPoint = self:getAnchorPoint()
--     local _size = self:getContentSize()
--     local _x = x * self.mapWidth
--     local _y = y * self.mapHeight
--     display.newSprite("mgd_10.png")
--         :move(_x, _y)
--         :setScale(0.2)
--         :addTo(self)
--     local metatable = getmetatable(self)
--     metatable.setAnchorPoint(self, x, y)
-- end

function Wall:addTouch()
    self:onTouch(function (event)
        if event.name == "began" then
            self.touchX = event.x
            self.touchY = event.y
            self.posX, self.posY = self:getPosition()

            return true
        elseif event.name == "moved" then

            self:setPosition(self.posX+event.x-self.touchX, self.posY+event.y-self.touchY)
        end
    end)
end

function Wall:checkMove()
    local _x = self.idleX
    local _y = self.idleY
    self.moving = nil
    if self:checkEnd(_x, _y) then
        self.parent.role:idle()
        local _layer = display.newLayer(cc.c4b(0,0,0,255))
            :setContentSize(400, 100)
            :move(display.cx - 200, display.cy + 200)
            :addTo(self.parent)
        cc.Label:createWithSystemFont("Game clearance", "Arial", 40)
            :move(200,50)
            :addTo(_layer)
        return
    end
    local _situation = self:checkAround(_x, _y)
    local _l, _r, _u, _d
    if _situation == Const.noRoad then
        _l = false; _r = false; _u = false; _d = true
        self.parent.role:idle()
        self.parent:showWarn()
    elseif _situation == Const.lRoad then
        _l = false; _r = false; _u = false; _d = false
        self:turn(Const.left)
    elseif _situation == Const.uRoad then
        _l = false; _r = false; _u = false; _d = false
        self:goAhead()
    elseif _situation == Const.luRoad then
        _l = true; _r = false; _u = true; _d = false
        self.parent.role:idle()
        self.parent:showWarn()
    elseif _situation == Const.rRoad then
        _l = false; _r = false; _u = false; _d = false
        self:turn(Const.right)
    elseif _situation == Const.lrRoad then
        _l = true; _r = true; _u = false; _d = false
        self.parent.role:idle()
        self.parent:showWarn()
    elseif _situation == Const.urRoad then
        _l = false; _r = true; _u = true; _d = false
        self.parent.role:idle()
        self.parent:showWarn()
    elseif _situation == Const.lurRoad then
        _l = true; _r = true; _u = true; _d = false
        self.parent.role:idle()
        self.parent:showWarn()
    end
    self.parent:greyUBtn(_u)
    self.parent:greyLBtn(_l)
    self.parent:greyRBtn(_r)
    self.parent:greyDBtn(_d)

end

function Wall:checkAround(_x, _y, _direction)
    local _situation = 0
    _direction = _direction or self.direction
    if _direction == Const.up then
        if self:checkNum(_x, _y+1) then
            _situation = 2 + _situation
            if self:checkNum(_x-1, _y+1) then
                _situation = _situation - 2
                _situation = 1 + _situation
            end
            if self:checkNum(_x+1, _y+1) then
                if _situation == 2 then
                    _situation = _situation - 2
                end
                _situation = 4 + _situation
            end
            if self:checkNum(_x, _y+2) then
                if _situation == 2 then
                    _situation = _situation - 2
                end
                _situation = 2 + _situation
            end
        else
            if self:checkNum(_x-1, _y) then
                self.pirouette = true
                _situation = 1 + _situation
            end
            if self:checkNum(_x+1, _y) then
                self.pirouette = true
                _situation = 4 + _situation
            end
        end
    elseif _direction == Const.left then
        if self:checkNum(_x-1, _y) then
            _situation = 2 + _situation
            if self:checkNum(_x-1, _y-1) then
                _situation = _situation - 2
                _situation = 1 + _situation
            end
            if self:checkNum(_x-1, _y+1) then
                if _situation == 2 then
                    _situation = _situation - 2
                end
                _situation = 4 + _situation
            end
            if self:checkNum(_x-2, _y) then
                if _situation == 2 then
                    _situation = _situation - 2
                end
                _situation = 2 + _situation
            end
        else
            if self:checkNum(_x, _y-1) then
                self.pirouette = true
                _situation = 1 + _situation
            end
            if self:checkNum(_x, _y+1) then
                self.pirouette = true
                _situation = 4 + _situation
            end
        end

    elseif _direction == Const.down then
        if self:checkNum(_x, _y-1) then
            _situation = 2 + _situation
            if self:checkNum(_x+1, _y-1) then
                _situation = _situation - 2
                _situation = 1 + _situation
            end
            if self:checkNum(_x-1, _y-1) then
                if _situation == 2 then
                    _situation = _situation - 2
                end
                _situation = 4 + _situation
            end
            if self:checkNum(_x, _y-2) then
                if _situation == 2 then
                    _situation = _situation - 2
                end
                _situation = 2 + _situation
            end
        else
            if self:checkNum(_x+1, _y) then
                self.pirouette = true
                _situation = 1 + _situation
            end
            if self:checkNum(_x-1, _y) then
                self.pirouette = true
                _situation = 4 + _situation
            end
        end
    elseif _direction == Const.right then
        if self:checkNum(_x+1, _y) then
            _situation = 2 + _situation
            if self:checkNum(_x+1, _y+1) then
                _situation = _situation - 2
                _situation = 1 + _situation
            end
            if self:checkNum(_x+1, _y-1) then
                if _situation == 2 then
                    _situation = _situation - 2
                end
                _situation = 4 + _situation
            end
            if self:checkNum(_x+2, _y) then
                if _situation == 2 then
                    _situation = _situation - 2
                end
                _situation = 2 + _situation
            end
        else
            if self:checkNum(_x, _y+1) then
                self.pirouette = true
                _situation = 1 + _situation
            end
            if self:checkNum(_x, _y-1) then
                self.pirouette = true
                _situation = 4 + _situation
            end
        end
    end
    print(_situation, "_situation")
    return _situation
end

function Wall:checkNum(x, y)
    if self.config[x] and self.config[x][y] and self.config[x][y] ~= 0 then
        return true
    end
    return false
end

function Wall:checkStart()
    local _situation
    -- for i=0,3 do
    --     _situation = self:checkAround(self.startPoint.x, self.startPoint.y, i)
    --     if _situation ~= Const.noRoad and _situation ~= Const.lRoad 
    --         and _situation ~= Const.rRoad and _situation ~= Const.lrRoad then
    --         self.direction = i
    --         break
    --     end
    -- end
    local _x, _y = self.startPoint.x, self.startPoint.y

    if self:checkNum(_x, _y+1) then
        self.direction = Const.up
    elseif self:checkNum(_x, _y-1) then
        self.direction = Const.down
    elseif self:checkNum(_x-1, _y) then
        self.direction = Const.left
    elseif self:checkNum(_x+1, _y) then
        self.direction = Const.right
    end
    if self.direction == Const.up then
        self:checkShowPoint(_x, _y + 1)
    elseif self.direction == Const.left then
        self:checkShowPoint(_x - 1, _y)
        self:changeAnchorPoint()
        self:setRotation(90)
    elseif self.direction == Const.right then
        self:checkShowPoint(_x + 1, _y)
        self:changeAnchorPoint()
        self:setRotation(-90)
    elseif self.direction == Const.down then
        self:checkShowPoint(_x, _y - 1)
        self:changeAnchorPoint()
        self:setRotation(180)
    end


end
return Wall