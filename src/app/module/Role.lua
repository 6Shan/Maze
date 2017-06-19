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

function Role:walkTo()
	if self.state == Const.move then
		return
	end
	local _frameX, _frameY, _frame, _x, _y
	
	local _time = cc.DelayTime:create(self.walkSpeed)
	local _call = cc.CallFunc:create(function()
		_frame = self.spriteFrame % Const.roleFrame
		self.spriteFrame = _frame + 1
		_frameX = _frame * Const.roleWidth
		_frameY = 3 * Const.roleHeight
		self:setTextureRect(cc.rect(_frameX, _frameY, Const.roleWidth, Const.roleHeight))
	end)
	local _seq = cc.Sequence:create(_call, _time)
	self.moveAction = cc.RepeatForever:create(_seq)
	self:runAction(self.moveAction)
	self.state = Const.move
end

function Role:startMove()
	local _move = cc.MoveBy:create(Const.speed, cc.p(0, Const.wallHeight))
	local _call = cc.CallFunc:create(function ()
		self.parent.mapLayer:checkMove()
	end)
	local _seq = cc.Sequence:create(_move, _call)
	self:walkTo()
	self:runAction(_seq)
end

function Role:idle()
	local _frameX, _frameY = 0, 3 * Const.roleHeight
	if self.moveAction then
		self:stopAction(self.moveAction)
		self.moveAction = nil
	end
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