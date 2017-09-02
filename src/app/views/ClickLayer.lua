local ClickLayer = class("ClickLayer", cc.Layer)

function ClickLayer:init(list)
	self.btnList = list
	self:onTouch(function (event)
		local parent = self:getParent()
		if event.name == "began" then
			for k,btn in pairs(self.btnList) do
				if cc.rectContainsPoint(btn:getBoundingBox(), cc.p(event.x, event.y)) then
					parent:onTouchBtn(btn, ccui.TouchEventType.began)
					parent.pressBtn = btn
					-- performWithDelay(self, function()
					-- 	if parent.pressBtn then
					-- 		parent:onTouchBtn(parent.pressBtn, ccui.TouchEventType.ended)
					-- 	end
					-- end, 0.2)
					-- performWithDelay(self, function()
					-- 	if parent.pressBtn then
					-- 		parent:onTouchBtn(parent.pressBtn, ccui.TouchEventType.began)
					-- 	end
					-- end, 0.3)
					return true
				end
			end
			return true
		elseif event.name == "moved" then
			if parent.pressBtn then
				if not cc.rectContainsPoint(parent.pressBtn:getBoundingBox(), cc.p(event.x, event.y)) then
					-- self:stopAllActions()
					parent:onTouchBtn(parent.pressBtn, ccui.TouchEventType.ended)
					parent.pressBtn = nil
				end
			else
				for k,btn in pairs(self.btnList) do
					if cc.rectContainsPoint(btn:getBoundingBox(), cc.p(event.x, event.y)) then
						parent:onTouchBtn(btn, ccui.TouchEventType.began)
						parent.pressBtn = btn
						return
					end
				end
			end
		elseif event.name == "ended" then
			if parent.pressBtn then
				if cc.rectContainsPoint(parent.pressBtn:getBoundingBox(), cc.p(event.x, event.y)) then
					-- self:stopAllActions()
					parent:onTouchBtn(parent.pressBtn, ccui.TouchEventType.ended)
					parent.pressBtn = nil
				end
			end
		end
	end)
end
return ClickLayer
