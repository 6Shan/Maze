local EditScene = class("EditScene", cc.load("mvc").ViewBase)

function EditScene:onCreate()

	cc.LayerColor:create(cc.c4b(0, 10, 155, 155))
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

	self.complete = cc.Label:createWithSystemFont("完成", "Arial", 24)
			    	:move(display.cx + 120, display.top - 50)
			    	:addTo(self)

    ccui.Button:create("mgd_30.png")
    	:setScale(0.5)
    	:move(38, -12)
    	:addTo(self.complete)
    	:addTouchEventListener(function (sender, event) 
    		if event == ccui.TouchEventType.ended then
    			local fileUtil = cc.FileUtils:getInstance()
    			local path = fileUtil:getWritablePath().."map.lua"
    			local file = io.open(path, "w+b")
    			if file then
    				local str = Utils.serialize(self.mapArray)
    				file:write(str)
    				io.close(file)
    			end
    		end
    	end)

    self.zoomIn = ccui.Button:create("mgd_19.png")
    				:setScale(0.4)
			    	:move(display.left + 50, display.top - 150)
			    	:addTo(self)
			    	:addTouchEventListener(function (sender, event)
			    		if event == ccui.TouchEventType.ended then
			    			self:setMapScale(self.scaleNum + 0.2)
			    		end
			    	end)

    self.zoomOut = ccui.Button:create("mgd_20.png")
    				:setScale(0.4)
			    	:move(display.right - 50, display.top - 150)
			    	:addTo(self)
			    	:addTouchEventListener(function (sender, event)
			    		if event == ccui.TouchEventType.ended then
			    			self:setMapScale(self.scaleNum - 0.2)
			    		end
			    	end)

    self.undo = ccui.Button:create("mgd_28.png")
    				:setScale(0.15)
			    	:move(display.left + 250, display.top - 150)
			    	:addTo(self)
			    	:addTouchEventListener(function (sender, event) 
			    		if event == ccui.TouchEventType.ended then
			    			if self.stepIndex == 0 then
			    				return
			    			end
				    		local _step = self.stepList[self.stepIndex]
			    			print("undo", self.stepIndex)
			    			Utils.printTable(self.stepList)
				    		for _,tbl in pairs(_step) do
				    			if tbl[4] then
			    					self:changeMaze(tbl[1], tbl[2], tbl[3])
			    				else
			    					self:changeMaze(tbl[1], tbl[2], Const.clean)
			    				end
				    		end
				    		self.stepIndex = self.stepIndex - 1
				    	end
			    	end)

    self.redo = ccui.Button:create("mgd_28.png")
    				:setScaleX(-0.15)
    				:setScaleY(0.15)
			    	:move(display.right - 250, display.top - 150)
			    	:addTo(self)
					:addTouchEventListener(function (sender, event) 
						if event == ccui.TouchEventType.ended then
							local _len = #self.stepList
							if self.stepIndex == _len then
								return
							end
							print("redo", self.stepIndex, _len)
							self.stepIndex = self.stepIndex + 1
				    		local _step = self.stepList[self.stepIndex]
				    		for _,tbl in pairs(_step) do
				    			if not tbl[4] then
			    					self:changeMaze(tbl[1], tbl[2], tbl[3])
			    				else
			    					self:changeMaze(tbl[1], tbl[2], Const.clean)
			    				end
				    		end
				    	end
					end)

	self.start = ccui.Button:create("mgd_10.png")
					:setScale(0.5)
					:move(display.cx - 212, display.bottom + 80)
					:addTo(self)
	self.start:addTouchEventListener(function (sender, event) 
		if event == ccui.TouchEventType.began then
			self:selectState(Const.start, sender)
			self.editMap:setTouchEnabled(false)
		end
	end)
	self.btnSize = self.start:getContentSize()
	local _width = self.btnSize.width / 2
	local _height = self.btnSize.height / 2

	cc.Label:createWithSystemFont("起点", "Arial", 40)
			    	:move(_width, -10)
			    	:addTo(self.start)
	
	self.ended = ccui.Button:create("mgd_06.png")
					:setScale(0.5)
					:move(display.cx - 106, display.bottom + 80)
					:addTo(self)
	self.ended:addTouchEventListener(function (sender, event) 
		if event == ccui.TouchEventType.began then
			self:selectState(Const.ended, sender)
			self.editMap:setTouchEnabled(false)
		end
	end)
	cc.Label:createWithSystemFont("终点", "Arial", 40)
			    	:move(_width, -10)
			    	:addTo(self.ended)
	
	self.drag = ccui.Button:create("mgd_16.png")
					:setScale(0.5)
					:move(display.cx, display.bottom + 80)
					:addTo(self)
	self.drag:addTouchEventListener(function (sender, event) 
		if event == ccui.TouchEventType.began then
			self:selectState(Const.drag, sender)
			self.editMap:setTouchEnabled(true)
		end
	end)
	cc.Label:createWithSystemFont("拖动", "Arial", 40)
			    	:move(_width, -10)
			    	:addTo(self.drag)
	
	self.road = ccui.Button:create("mgd_09.png")
					:setScale(0.5)
					:move(display.cx + 106, display.bottom + 80)
					:addTo(self)
	self.road:addTouchEventListener(function (sender, event) 
		if event == ccui.TouchEventType.began then
			self:selectState(Const.road, sender)
			self.editMap:setTouchEnabled(false)
		end
	end)
	cc.Label:createWithSystemFont("道路", "Arial", 40)
			    	:move(_width, -10)
			    	:addTo(self.road)
	
	self.clean = ccui.Button:create("mgd_12.png")
					:setScale(0.5)
					:move(display.cx + 212, display.bottom + 80)
					:addTo(self)
	self.clean:addTouchEventListener(function (sender, event) 
		if event == ccui.TouchEventType.began then
			self:selectState(Const.clean, sender)
			self.editMap:setTouchEnabled(false)
		end
	end)
	cc.Label:createWithSystemFont("清除", "Arial", 40)
			    	:move(_width, -10)
			    	:addTo(self.clean)

	self.selectSpr = display.newSprite("mgd_13.png")
						:move(cc.p(-200, -200))
						:addTo(self)

	self.scaleNum = 1
end

function EditScene:initPanel(pointHeight, editHeight, mapHeight)
	self.pointHeight = height or 54
	self.editHeight = editHeight or 580
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
	self.editRect = cc.rect(display.cx - _editSize.width / 2, display.cy - _editSize.height / 2, 
						_editSize.width, _editSize.height)
	local _node = display.newLayer()
					:addTo(self.editMap)

	self.mapLayer = cc.LayerColor:create(cc.c4b(255, 255, 255, 255))
					:move(0, 0)
					-- :setScale(self.editHeight / self.mapHeight)
					:setAnchorPoint(cc.p(0, 0))
					:setContentSize(_mapHeight)
					:addTo(_node)
	self.mapLayer:onTouch(function (event)
		if event.name == "began" then
			local _bool = false
			_bool = cc.rectContainsPoint(self.editRect, cc.p(event.x, event.y))
			if _bool then
				if self.haveStart and self.state == Const.start then
					return false
				elseif self.haveEnded and self.state == Const.ended then
					return false
				end
				self.step = {}
				self.stepIndex = self.stepIndex + 1
				self:saveStep(event.x, event.y)
				self:changeMaze(event.x, event.y)
			end
			return _bool
		elseif event.name == "moved" then
			self:saveStep(event.x, event.y)
			self:changeMaze(event.x, event.y)
		elseif event.name == "ended" then
			self.stepList[self.stepIndex] = self.step
		end
	end)

	self.lineNode = cc.DrawNode:create()
					:addTo(self.mapLayer)
	local _total = self.mapHeight / self.pointHeight
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
	self:selectState(Const.start, self.start)
	self:setMapScale(self.minScale)

	self.stepList = {}
	self.stepIndex = 0
end

function EditScene:selectState(state, sender)
	local _width = self.btnSize.width / 2
	local _height = self.btnSize.height / 2
	self.selectSpr:retain()
		:move(_width, _height - 10)
		:removeSelf()
		:addTo(sender)
		:release()
	self.state = state
end

function EditScene:changeMaze(x, y, _state)
	local _x, _y
	local _pos = self.mapLayer:convertToNodeSpace(cc.p(x, y))
	_pos,_x,_y = self:changePos(_pos)
	print(_x,_y,_state, debug.traceback())
	_state = _state or self.state
	print(_state)
	if _state == Const.start then
		if not self.haveStart then
			self.mapArray[_x][_y] = _state
			self.mapArray.start = cc.p(_x, _y)
			self.lineNode:drawSolidRect(cc.p(_pos.x, _pos.y),
				 cc.p(_pos.x + self.pointHeight, _pos.y + self.pointHeight), cc.c4f(0, 1, 0, 1))
			self.haveStart = true
		end
	elseif _state == Const.ended then
		if not self.haveEnded then
			self.mapArray[_x][_y] = _state
			self.mapArray.ended = cc.p(_x, _y)
			self.lineNode:drawSolidRect(cc.p(_pos.x, _pos.y),
				 cc.p(_pos.x + self.pointHeight, _pos.y + self.pointHeight), cc.c4f(1, 0, 0, 1))
			self.haveEnded = true
		end
	elseif _state == Const.road then
		self.mapArray[_x][_y] = _state
		self.lineNode:drawSolidRect(cc.p(_pos.x, _pos.y),
				 cc.p(_pos.x + self.pointHeight, _pos.y + self.pointHeight), cc.c4f(0, 0, 0, 1))
	elseif _state == Const.clean then
		if self.mapArray[_x][_y] == Const.start then
			self.haveStart = nil
		elseif self.mapArray[_x][_y] == Const.ended then
			self.haveEnded = nil
		end
		self.mapArray[_x][_y] = 0
		self.lineNode:drawSolidRect(cc.p(_pos.x, _pos.y),
				 cc.p(_pos.x + self.pointHeight, _pos.y + self.pointHeight),  cc.c4f(1, 1, 1, 1))
	end
end

function EditScene:saveStep(x, y)
	local _x, _y
	local _pos = self.mapLayer:convertToNodeSpace(cc.p(x, y))
	_pos,_x,_y = self:changePos(_pos)
	local _len = #self.stepList - 1
	for i=self.stepIndex,_len do
		self.stepList[i] = nil
	end
	if self.state == Const.clean then
		if self.mapArray[_x][_y] ~= 0 then
			table.insert(self.step, {x, y, self.mapArray[_x][_y], true})
		end
	else
		table.insert(self.step, {x, y, self.state})
	end
end

function EditScene:changePos(pos)
	local _x = math.floor(pos.x / self.pointHeight)
	local _y = math.floor(pos.y / self.pointHeight)
	return cc.p(_x * self.pointHeight, _y * self.pointHeight),_x + 1,_y + 1
end

function EditScene:setMapScale(scale)
	if scale > self.maxScale then
		scale = self.maxScale
	elseif scale < self.minScale then
		scale = self.minScale
	end
	self.scaleNum = scale
	self.mapLayer:setScale(scale)
	self.editMap:setInnerContainerSize(cc.size(self.mapHeight * scale, self.mapHeight * scale))
end

return EditScene