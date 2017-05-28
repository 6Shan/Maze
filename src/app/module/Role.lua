local Role = class("Role", cc.Sprite)
function Role:init()
	self.texture = cc.Director:getInstance():getTextureCache():addImage("mgd_03.png")
	self:setTexture(self.texture)
	self.spriteFrame = Const.roleFrame
	self:addShadow()
	-- self:setTextureRect(cc.rect(30,50,30,50))
end

local x = 32
local y = 48
local width = 32
local height = 48

function Role:walkTo(direction)
	local _x, _y, _frame

	local c = function ()
		_frame = self.spriteFrame % Const.roleFrame
		self.spriteFrame = _frame + 1
		_x = _frame * Const.roleWidth
		_y = direction * Const.roleHeight
		-- if i < 5 then
		-- 	_x = x * (i - 1)
		-- 	_y = 0
		-- elseif i < 9 then
		-- 	_x = x * (i - 5)
		-- 	_y = y * 1
		-- elseif i < 13 then
		-- 	_x = x * (i - 9)
		-- 	_y = y * 2
		-- elseif i < 17 then
		-- 	_x = x * (i - 13)
		-- 	_y = y * 3
		-- else
		-- 	i = 1
		-- end
		-- i = i + 1
		self:setTextureRect(cc.rect(_x, _y, Const.roleWidth, Const.roleHeight))
	end
	schedule(self, c, 0.2)
end

function Role:addShadow()
	display.newSprite("mgd_26.png")
		:move(Const.roleWidth / 2, 0)
		:setScale(0.2)
		:addTo(self)
end
return Role