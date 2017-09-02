local EditScene = class("EditScene", cc.load("mvc").ViewBase)

function EditScene:onCreate()

	cc.LayerColor:create(cc.c4b(128, 128, 128, 155))
		:move(display.left, display.bottom)
		:setContentSize(cc.size(640, 960))
		:addTo(self)

	self.giveup = cc.Label:createWithSystemFont("放弃", "Arial", 32)
					:move(display.cx - 120, display.top - 50)
					:addTo(self)

	ccui.Button:create("mgd_30.png")
		:setScale(-0.8)
		:move(10, -16)
		:addTo(self.giveup)
		:addTouchEventListener(function (sender, event) 
			local map = self:getApp():createView("MainScene")
			map:showWithScene()
		end)

	self.complete = cc.Label:createWithSystemFont("完成", "Arial", 32)
					:move(display.cx + 120, display.top - 50)
					:addTo(self)

	ccui.Button:create("mgd_30.png")
		:setScale(0.8)
		:move(50, -16)
		:addTo(self.complete)
		:addTouchEventListener(function (sender, event) 
			if event == ccui.TouchEventType.ended then
				local fileUtil = cc.FileUtils:getInstance()
				local path = fileUtil:getWritablePath().."map.json"
				local str = ""
				for i=self.minX,self.maxX do
					for j=self.minY,self.maxY do
						str = str .. self.mapArray[i][j]
						-- if self.mapArray[i][j] == Const.start then
						-- 	temp.start = cc.p(iT, jT)
						-- elseif self.mapArray[i][j] == Const.ended then
						-- 	temp.ended = cc.p(iT, jT)
						-- end
					end
				end
				GameClient.editMapData.maze_map = str
				GameClient.editMapData.height = self.maxY - self.minY + 1
				GameClient.editMapData.width = self.maxX - self.minX + 1
				str = json.encode(GameClient.editMapData)
				io.writefile(path, str)
			end
		end)

	-- self.zoomIn = ccui.Button:create("mgd_19.png")
	-- 				:setScale(0.4)
	-- 				:move(display.left + 50, display.top - 150)
	-- 				:addTo(self)
	-- 				:addTouchEventListener(function (sender, event)
	-- 					if event == ccui.TouchEventType.ended then
	-- 						self:setMapScale(self.scaleLevel + 1)
	-- 					end
	-- 				end)

	-- self.zoomOut = ccui.Button:create("mgd_20.png")
	-- 				:setScale(0.4)
	-- 				:move(display.right - 50, display.top - 150)
	-- 				:addTo(self)
	-- 				:addTouchEventListener(function (sender, event)
	-- 					if event == ccui.TouchEventType.ended then
	-- 						self:setMapScale(self.scaleLevel - 1)
	-- 					end
	-- 				end)

	self.undo = ccui.Button:create("mgd_28.png")
					:setScale(0.2)
					:move(display.left + 80, display.top - 150)
					:addTo(self)
					:addTouchEventListener(function (sender, event) 
						if event == ccui.TouchEventType.ended then
							if self.stepIndex == 0 then
								return
							end
							self.stopSave = true
							Utils.printTable("self.stepList",self.stepList)
							local _step = self.stepList[self.stepIndex]
							for _,tbl in pairs(_step) do
								local _x, _y, _state = tbl[1], tbl[2], tbl[3]
								print("selfddddd", _x, _y, _state, tbl[4])
								if tbl[4] then
									if _state == Const.start then
										local _pos = self.mapLayer:convertToNodeSpace(cc.p(_x, _y))
										_pos,_x,_y = self:changePos(_pos)
										self:addStartPoint(_x, _y, _pos, tbl[1], tbl[2])
									elseif _state == Const.ended then
										local _pos = self.mapLayer:convertToNodeSpace(cc.p(_x, _y))
										_pos,_x,_y = self:changePos(_pos)
										self:addEndPoint(_x, _y, _pos, tbl[1], tbl[2])
									else
										self:changeMaze(_x, _y, Const.road)
									end
								else
									if _state == Const.start then
										self:removeStartPoint()
									elseif _state == Const.ended then
										self:removeEndPoint()
									else
										self:changeMaze(_x, _y, Const.clean)
									end
								end
							end
							self.stepIndex = self.stepIndex - 1
							self.stopSave = nil
						end
					end)

	self.redo = ccui.Button:create("mgd_28.png")
					:setScale(-0.2, 0.2)
					:move(display.right - 80, display.top - 150)
					:addTo(self)
					:addTouchEventListener(function (sender, event) 
						if event == ccui.TouchEventType.ended then
							local _len = #self.stepList
							if self.stepIndex == _len then
								return
							end
							self.stopSave = true
							self.stepIndex = self.stepIndex + 1
							local _step = self.stepList[self.stepIndex]
							for _,tbl in pairs(_step) do
								local _x, _y, _state = tbl[1], tbl[2], tbl[3]
								print("se22332dd", _x, _y, _state, tbl[4])
								if not tbl[4] then
									if _state == Const.start then
										local _pos = self.mapLayer:convertToNodeSpace(cc.p(_x, _y))
										_pos,_x,_y = self:changePos(_pos)
										self:addStartPoint(_x, _y, _pos, tbl[1], tbl[2])
									elseif _state == Const.ended then
										local _pos = self.mapLayer:convertToNodeSpace(cc.p(_x, _y))
										_pos,_x,_y = self:changePos(_pos)
										self:addEndPoint(_x, _y, _pos, tbl[1], tbl[2])
									else
										self:changeMaze(_x, _y, Const.road)
									end
								else
									if _state == Const.start then
										self:removeStartPoint()
									elseif _state == Const.ended then
										self:removeEndPoint()
									else
										self:changeMaze(_x, _y, Const.clean)
									end
								end
							end
							self.stopSave = nil
						end
					end)

	self.labelSize = 28
	self.startLabel = cc.Label:createWithSystemFont("起点", "Arial", self.labelSize)
					:move(display.cx - 64, display.bottom + 30)
					:setAnchorPoint(0.5, 0)
					:addTo(self)
	self.start = ccui.Button:create("mgd_34.png")
					:setScale(0.5)
					:addTo(self.startLabel)
					:setAnchorPoint(0.5, 0)
	self.start:addTouchEventListener(function (sender, event) 
		if event == ccui.TouchEventType.began then
			self:onSelectStart()
		end
	end)
	self.btnSize = self.start:getContentSize()
	local _width = self.btnSize.width / 2
	local _height = self.btnSize.height / 2
	local _lSize = self.startLabel:getContentSize()
	self.start:move(self.labelSize, self.labelSize)
	
	self.endedLabel = cc.Label:createWithSystemFont("终点", "Arial", self.labelSize)
					:move(display.cx + 64, display.bottom + 30)
					:setAnchorPoint(0.5, 0)
					:addTo(self)
	self.ended = ccui.Button:create("mgd_35.png")
					:setScale(0.5)
					:setAnchorPoint(0.5, 0)
					:addTo(self.endedLabel)
					:move(self.labelSize, self.labelSize)
	self.ended:addTouchEventListener(function (sender, event) 
		if event == ccui.TouchEventType.began then
			self:onSelectEnd()
		end
	end)
	
	self.dragLabel = cc.Label:createWithSystemFont("按住不放", "Arial", self.labelSize)
					:move(display.cx - 192, display.bottom + 30)
					:setAnchorPoint(0.5, 0)
					:addTo(self)
	self.drag = ccui.Button:create("mgd_16.png")
					:setScale(0.5)
					:addTo(self.dragLabel)
					:setAnchorPoint(0.5, 0)
					:move(self.labelSize * 2, self.labelSize)
	self.drag:addTouchEventListener(function (sender, event) 
		if event == ccui.TouchEventType.began then
			-- self:selectState(Const.drag, sender)
			self.editMap:setTouchEnabled(true)
			self.holdTime = os.clock()
		elseif event == ccui.TouchEventType.ended then
			local time = os.clock()
			if time - self.holdTime < 0.2 then
				self:setMapScale()
			end
			self.editMap:setTouchEnabled(false)
		end
	end)
	
	self.roadLabel = cc.Label:createWithSystemFont("建造道路", "Arial", self.labelSize)
					:move(display.cx + 192, display.bottom + 30)
					:setAnchorPoint(0.5, 0)
					:addTo(self)
	self.road = ccui.Button:create("mgd_37.png")
					:setScale(0.5)
					:setAnchorPoint(0.5, 0)
					:addTo(self.roadLabel)
					:move(self.labelSize * 2, self.labelSize)
	self.road:addTouchEventListener(function (sender, event) 
		if event == ccui.TouchEventType.began then
			self:onSelectRord()
		end
	end)
	self.state = Const.road
	
	self.pointList = {{{-1,-1},{0,-1},{-1,0}},{{1,-1},{0,-1},{1,0}},{{-1,1},{0,1},{-1,0}},{{1,1},{0,1},{1,0}}}
	-- self.clean = ccui.Button:create("mgd_12.png")
	-- 				:setScale(0.5)
	-- 				:move(display.cx + 212, display.bottom + 80)
	-- 				:addTo(self)
	-- self.clean:addTouchEventListener(function (sender, event) 
	-- 	if event == ccui.TouchEventType.began then
	-- 		self:selectState(Const.clean, sender)
	-- 		self.editMap:setTouchEnabled(false)
	-- 	end
	-- end)
	-- cc.Label:createWithSystemFont("清除", "Arial", 40)
	-- 				:move(_width, -10)
	-- 				:addTo(self.clean)

	-- self.selectSpr = display.newSprite("mgd_13.png")
	-- 					:move(cc.p(-200, -200))
	-- 					:addTo(self)
end

function EditScene:initPanel(pointHeight, editHeight, mapHeight)
	-- 默认值是32*32
	self.pointHeight = height or 25
	self.editHeight = editHeight or 550
	self.mapHeight = mapHeight or 2400
	self.minScale = self.editHeight / self.mapHeight
	self.pointScale = self.pointHeight / self.btnSize.width
	-- self.maxScale = 1
	local _scale = self.editHeight / self.pointHeight
	self.scaleList = {_scale / 8, _scale / 16, _scale / 32, _scale / 48, _scale / 64, _scale / 96}
	self.scaleLevel = 3
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
	-- self.editMap = cc.ScrollView:create(_editSize)
	-- 				:addTo(self)
	-- 				-- :setAnchorPoint(cc.p(0.5, 0.5))
	-- 				:setDirection(cc.SCROLLVIEW_DIRECTION_BOTH)
	-- 				:move(display.cx - self.editHeight/2, display.cy - self.editHeight/2)

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
				if not self.state then
					local string = self.roadLabel:getString()
					if string == "建造道路" then
						self.state = Const.road
					else
						self.state = Const.clean
					end
				end
				if self.state == Const.start or self.state == Const.ended then
					_bool = false
				elseif self.state == Const.clean or self.state == Const.road then
					self.step = {}
					self.stepIndex = self.stepIndex + 1
					self:saveStep(event.x, event.y, self.state)
				end
				self:changeMaze(event.x, event.y, self.state)
			end
			return _bool
		elseif event.name == "moved" then
			if not self.state then
				local string = self.roadLabel:getString()
				if string == "建造道路" then
					self.state = Const.road
				else
					self.state = Const.clean
				end
			end
			self:saveStep(event.x, event.y, self.state)
			self:changeMaze(event.x, event.y, self.state)
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
		self.lineNode:drawLine(cc.p(0, self.pointHeight * i), cc.p(self.mapHeight, self.pointHeight * i), cc.c4f(0, 0, 0, 0.5))
	end

	for i=0,_total do
		self.lineNode:drawLine(cc.p(self.pointHeight * i, 0), cc.p(self.pointHeight * i, self.mapHeight), cc.c4f(0, 0, 0, 0.5))
	end
	self:setMapScale(self.scaleLevel)

	self.stepList = {}
	self.stepIndex = 0
	self.minX = _total
	self.maxX = 1
	self.minY = _total
	self.maxY = 1
end

function EditScene:selectState(state, sender)
	local _width = self.btnSize.width / 2
	local _height = self.btnSize.height / 2
	-- self.selectSpr:retain()
	-- 	:move(_width, _height - 10)
	-- 	:removeSelf()
	-- 	:addTo(sender)
	-- 	:release()
	self.state = state
end

function EditScene:changeMaze(x, y, _state)
	local _x, _y
	local _pos = self.mapLayer:convertToNodeSpace(cc.p(x, y))
	_pos,_x,_y = self:changePos(_pos)
	if _state == Const.start then
		if _x > self.maxX then
			self.maxX = _x
		end
		if _x < self.minX then
			self.minX = _x
		end
		if _y > self.maxY then
			self.maxY = _y
		end
		if _y < self.minY then
			self.minY = _y
		end
		-- if self.startPoint then
		-- 	local _startX = self.startPoint.x
		-- 	local _startY = self.startPoint.y
		-- 	if self.mapArray[_startX][_startY] == Const.start and (_startX ~= _x or _startY ~= _y) then
		-- 		self.mapArray[_startX][_startY] = Const.road
		-- 		self.lineNode:drawSolidRect(cc.p((_startX - 1) * self.pointHeight, (_startY - 1) * self.pointHeight),
		-- 		 cc.p((_startX - 1) * self.pointHeight + self.pointHeight, (_startY - 1) * self.pointHeight + self.pointHeight), cc.c4f(0, 0, 0, 1))
		-- 	end
		-- end

		if self.mapArray[_x][_y] ~= Const.road then
			GameClient:showCenterTip("请选择蓝色格子作为起点")
			return
		end
		if self.endedPoint and self.endedPoint.x == _x and self.endedPoint.y == _y then
			self:onSelectEnd()
		end
		if not self.stopSave then
			self.step = {}
			self.stepIndex = self.stepIndex + 1
			self:saveStep(x, y, _state)
			self.stepList[self.stepIndex] = self.step
		end
		self:addStartPoint(_x, _y, _pos, x, y)
		-- self.lineNode:drawSolidRect(cc.p(_pos.x, _pos.y),
		-- 	 cc.p(_pos.x + self.pointHeight, _pos.y + self.pointHeight), cc.c4f(0, 1, 0, 1))
	elseif _state == Const.ended then
		if _x > self.maxX then
			self.maxX = _x
		end
		if _x < self.minX then
			self.minX = _x
		end
		if _y > self.maxY then
			self.maxY = _y
		end
		if _y < self.minY then
			self.minY = _y
		end
		-- if self.endedPoint then
		-- 	local _endX = self.endedPoint.x
		-- 	local _endY = self.endedPoint.y
		-- 	if self.mapArray[_endX][_endY] == Const.ended and (_endX ~= _x or _endY ~= _y) then
		-- 		self.mapArray[_endX][_endY] = Const.road
		-- 		self.lineNode:drawSolidRect(cc.p((_endX - 1) * self.pointHeight, (_endY - 1) * self.pointHeight),
		-- 		 cc.p((_endX - 1) * self.pointHeight + self.pointHeight, (_endY - 1) * self.pointHeight + self.pointHeight), cc.c4f(0, 0, 0, 1))
		-- 	end
		-- end
		if self.mapArray[_x][_y] ~= Const.road then
			GameClient:showCenterTip("请选择蓝色格子作为终点")
			return
		end
		if self.startPoint and self.startPoint.x == _x and self.startPoint.y == _y then
			self:onSelectStart()
		end
		if not self.stopSave then
			self.step = {}
			self.stepIndex = self.stepIndex + 1
			self:saveStep(x, y, _state)
			self.stepList[self.stepIndex] = self.step
		end
		self:addEndPoint(_x, _y, _pos, x, y)
		-- self.lineNode:drawSolidRect(cc.p(_pos.x, _pos.y),
		-- 	 cc.p(_pos.x + self.pointHeight, _pos.y + self.pointHeight), cc.c4f(1, 0, 0, 1))
	elseif _state == Const.road then
		if _x > self.maxX then
			self.maxX = _x
		elseif _x < self.minX then
			self.minX = _x
		end
		if _y > self.maxY then
			self.maxY = _y
		elseif _y < self.minY then
			self.minY = _y
		end
		if not self:checkPoint(_x, _y) then
			return
		end
		self.mapArray[_x][_y] = _state
		self.lineNode:drawSolidRect(cc.p(_pos.x, _pos.y),
				 cc.p(_pos.x + self.pointHeight, _pos.y + self.pointHeight), cc.c4f(0, 0, 0, 1))
	elseif _state == Const.clean then
		if self.startPoint and self.startPoint.x == _x and self.startPoint.y == _y then
			if not self.stopSave then
				self.stopSave = true
				self:saveStep(self.startPoint.posX, self.startPoint.posY, Const.start, true)
				self:onSelectStart()
				self.stopSave = nil
			else
				self:onSelectStart()
			end
		elseif self.endedPoint and self.endedPoint.x == _x and self.endedPoint.y == _y then
			if not self.stopSave then
				self.stopSave = true
				self:saveStep(self.endedPoint.posX, self.endedPoint.posY, Const.ended, true)
				self:onSelectEnd()
				self.stopSave = nil
			else
				self:onSelectEnd()
			end
		end
		self.mapArray[_x][_y] = 0
		self.lineNode:drawSolidRect(cc.p(_pos.x, _pos.y),
				 cc.p(_pos.x + self.pointHeight, _pos.y + self.pointHeight),  cc.c4f(1, 1, 1, 1))
	end
end

function EditScene:saveStep(x, y, _state, isRemove)
	print("ppppooooo",x,y,_state,self.stepIndex,debug.traceback())
	local _x, _y
	local _pos = self.mapLayer:convertToNodeSpace(cc.p(x, y))
	_pos,_x,_y = self:changePos(_pos)
	local _len = #self.stepList
	for i=self.stepIndex,_len do
		self.stepList[i] = nil
	end
	if _state == Const.clean then
		if self.mapArray[_x][_y] ~= 0 then
			table.insert(self.step, {x, y, Const.road, true})
		end
	elseif _state == Const.road then
		if self.mapArray[_x][_y] ~= Const.road then
			table.insert(self.step, {x, y, _state})
		end
	elseif _state == Const.start or _state == Const.ended then
		table.insert(self.step, {x, y, _state, isRemove})
	end
end

function EditScene:changePos(pos)
	local _x = math.floor(pos.x / self.pointHeight)
	local _y = math.floor(pos.y / self.pointHeight)
	return cc.p(_x * self.pointHeight, _y * self.pointHeight),_x + 1,_y + 1
end

function EditScene:setMapScale(scale)
	if scale > 6 then
		scale = 6
	elseif scale < 1 then
		scale = 1
	end
	self.scaleLevel = scale
	local _scale = self.scaleList[self.scaleLevel]
	self.mapLayer:setScale(_scale)
	-- self.editMap:setMaxScale(2)
	-- self.editMap:setZoomScale(1.5)
	self.editMap:setInnerContainerSize(cc.size(self.mapHeight * _scale, self.mapHeight * _scale))
end

function EditScene:onSelectStart()
	if self.startPoint then
		if not self.stopSave then
			self.step = {}
			self.stepIndex = self.stepIndex + 1
			self:saveStep(self.startPoint.posX, self.startPoint.posY, Const.start, true)
			self.stepList[self.stepIndex] = self.step
		end
		self:removeStartPoint()
	elseif self.state ~= Const.start then
		if self.state == Const.ended then
			self:onSelectEnd()
		end
		self.state = Const.start
		self.startLabel:setDimensions(self.labelSize * 4, self.labelSize * 2 + 5)
		self.startLabel:setString("选择格子作为起点")
	else
		self.state = nil
		self.startLabel:setDimensions(0, 0)
		self.startLabel:setString("起点")
	end
	local _size = self.startLabel:getContentSize()
	self.start:move(_size.width /2, _size.height)
end
function EditScene:addStartPoint(_x, _y, _pos, x, y)
	self.startPoint = cc.p(_x, _y)
	self.startPoint.posX = x
	self.startPoint.posY = y
	self.startImg = display.newSprite("mgd_34.png")
					:move(_pos)
					:addTo(self.lineNode)
					:setAnchorPoint(0, 0)
					:setScale(self.pointScale)
	
	self.state = nil
	self.startLabel:setDimensions(0, 0)
	self.start:loadTextureNormal("mgd_22.png")
	self.startLabel:setString("撤销起点")
	local _size = self.startLabel:getContentSize()
	self.start:move(_size.width/2, _size.height)
end
function EditScene:removeStartPoint()
	if not self.startPoint then return end
	self.startPoint = nil
	self.startImg:removeSelf()
	self.startImg = nil
	self.start:loadTextureNormal("mgd_34.png")
	self.state = nil
	self.startLabel:setDimensions(0, 0)
	self.startLabel:setString("起点")
	local _size = self.startLabel:getContentSize()
	self.start:move(_size.width/2, _size.height)
end

function EditScene:onSelectEnd()
	if self.endedPoint then
		if not self.stopSave then
			self.step = {}
			self.stepIndex = self.stepIndex + 1
			self:saveStep(self.endedPoint.posX, self.endedPoint.posY, Const.ended, true)
			self.stepList[self.stepIndex] = self.step
		end
		self:removeEndPoint()
	elseif self.state ~= Const.ended then
		if self.state == Const.start then
			self:onSelectStart()
		end
		self.state = Const.ended
		self.endedLabel:setDimensions(self.labelSize * 4, self.labelSize * 2 + 5)
		self.endedLabel:setString("选择格子作为终点")
	else
		self.state = nil
		self.endedLabel:setDimensions(0, 0)
		self.endedLabel:setString("终点")
	end
	local _size = self.endedLabel:getContentSize()
	self.ended:move(_size.width /2, _size.height)
end
function EditScene:addEndPoint(_x, _y, _pos, x, y)
	print("_xsdofpisp",_x,_y,_pos.x,_pos.y)
	self.endedPoint = cc.p(_x, _y)
	self.endedPoint.posX = x
	self.endedPoint.posY = y
	self.endedImg = display.newSprite("mgd_35.png")
			:addTo(self.lineNode)
			:move(_pos)
			:setAnchorPoint(0, 0)
			:setScale(self.pointScale)

	self.state = nil
	self.endedLabel:setDimensions(0, 0)
	self.ended:loadTextureNormal("mgd_22.png")
	self.endedLabel:setString("撤销终点")
	local _size = self.endedLabel:getContentSize()
	self.ended:move(_size.width/2, _size.height)
end
function EditScene:removeEndPoint()
	if not self.endedPoint then return end
	self.endedPoint = nil
	self.endedImg:removeSelf()
	self.endedImg = nil
	self.state = nil
	self.ended:loadTextureNormal("mgd_35.png")
	self.endedLabel:setDimensions(0, 0)
	self.endedLabel:setString("终点")
	local _size = self.endedLabel:getContentSize()
	self.ended:move(_size.width/2, _size.height)
end

function EditScene:onSelectRord()
	if self.state == Const.start then
		self:onSelectStart()
	elseif self.state == Const.ended then
		self:onSelectEnd()
	end
	local string = self.roadLabel:getString()
	if string == "建造道路" then
		self.state = Const.clean
		self.roadLabel:setString("清除道路")
		self.road:loadTextureNormal("mgd_36.png")
	else
		self.state = Const.road
		self.roadLabel:setString("建造道路")
		self.road:loadTextureNormal("mgd_37.png")
	end
end

function EditScene:checkPoint(x, y)
	local flag = true
	for _,tbl in pairs(self.pointList) do
		for _,v in pairs(tbl) do
			if not(self.mapArray[x+v[1]] and self.mapArray[x+v[1]][y+v[2]] and self.mapArray[x+v[1]][y+v[2]] ~= 0) then
				flag = false
			end
		end
		if flag then
			return false
		end
		flag = true
	end
	return true
end

return EditScene