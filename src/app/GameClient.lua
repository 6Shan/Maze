cc.exports.GameClient = {}

function GameClient:showCenterTip(text)
	if self.panel then
    	self.panel:stopAllActions()
    	self.panel:setOpacity(255)
    else
    	self.panel = cc.LayerColor:create(cc.c4b(0, 0, 0, 255))
    	self.tipText = cc.Label:createWithTTF("", "simsun.ttf", 28)
    	self.panel:addChild(self.tipText)
    	if display.getRunningScene() then
            display.getRunningScene():addChild(self.panel, Const.Layer.max)
        else
        	return
        end
    end
	
	self.tipText:setString(text)
	
	local s = self.tipText:getContentSize()
	s.width = s.width + 50
	s.height = 50
	self.panel:setContentSize(s)
	local _width = s.width / 2
	local _height = s.height / 2
	self.tipText:setPosition(_width, _height)
	self.panel:setScale(0, 0)
	self.panel:setPosition(display.cx - _width, display.cy + 50)
    
	local move = cc.MoveTo:create(0.2, cc.p(display.cx - _width, display.cy - _height))
	local scale = cc.ScaleTo:create(0.2, 1.2)
    local callBack = cc.CallFunc:create(function()
	    	if self.panel then
		    	self.panel:removeFromParent()
		    	self.panel = nil
		    end
    	end)
    local seq = cc.Sequence:create(cc.Spawn:create(move, scale), cc.ScaleTo:create(0.1, 1), cc.DelayTime:create(1.5), cc.FadeOut:create(0.5), callBack)
    self.panel:runAction(seq)
end