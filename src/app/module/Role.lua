local Role = class("Role", cc.Sprite)
function Role:init(parent)
	self.texture = cc.Director:getInstance():getTextureCache():addImage("mgd_03.png")
	self:setTexture(self.texture)
	self.spriteFrame = 1
	self:addShadow()
	-- self:setTextureRect(cc.rect(30,50,30,50))
	self.walkSpeed = Const.speed / Const.roleFrame
	self.parent = parent
end

function Role:walkTo(direction)
	if self.state == Const.move then
		return
	end
	local _frameX, _frameY, _frame, _x, _y
	-- local c = function ()
	-- 	_frame = self.spriteFrame % Const.roleFrame
	-- 	self.spriteFrame = _frame + 1
	-- 	_frameX = _frame * Const.roleWidth
	-- 	_frameY = direction * Const.roleHeight
	-- 	self:setTextureRect(cc.rect(_frameX, _frameY, Const.roleWidth, Const.roleHeight))
	-- end
	-- schedule(self, c, 0.2)
	
	local _time = cc.DelayTime:create(self.walkSpeed)
	local _call = cc.CallFunc:create(function()
		_frame = self.spriteFrame % Const.roleFrame
		self.spriteFrame = _frame + 1
		_frameX = _frame * Const.roleWidth
		_frameY = direction * Const.roleHeight
		self:setTextureRect(cc.rect(_frameX, _frameY, Const.roleWidth, Const.roleHeight))
	end)
	local _seq = cc.Sequence:create(_call, _time)
	self.moveAction = cc.RepeatForever:create(_seq)
	self:runAction(self.moveAction)
	if direction == Const.up then
		_x = 0
		_y = Const.roleHeight
	elseif direction == Const.down then
		_x = 0
		_y = -Const.roleHeight
	elseif direction == Const.left then
		_x = -Const.roleHeight
		_y = 0
	elseif direction == Const.right then
		_x = Const.roleHeight
		_y = 0
	end
	local _posX, _posY = self:getPosition()
	if not self.parent:checkMove(_posX + _x, _posY + _y) then
		return
	end
	local _move = cc.MoveBy:create(Const.speed, cc.p(_x, _y))
	_call = cc.CallFunc:create(function()
		self.parent:checkEnd(self:getPosition())
		if self.parent.pressBtn then
			local _direction = self.parent.pressBtn:getTag()
			self:idle(_direction)
			self:walkTo(_direction)
		else
			self:idle(direction)
		end
	end)
	_seq = cc.Sequence:create(_move, _call)
	self:runAction(_seq)
	self.state = Const.move
end

function Role:idle(direction)
	local _frameX, _frameY = 0, direction * Const.roleHeight
	self:stopAction(self.moveAction)
	self:setTextureRect(cc.rect(_frameX, _frameY, Const.roleWidth, Const.roleHeight))
	self.state = Const.idle
end

function Role:addShadow()
	display.newSprite("mgd_26.png")
		:move(Const.roleWidth / 2, 0)
		:setScale(0.2)
		:addTo(self)
end
return Role