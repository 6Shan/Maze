cc.exports.Utils = {}

function Utils.printTable(...)
	-- if __HIDE_TEST__ then return end
	
	local args = {...}
	local fromIndex = 1

	if type(args[fromIndex]) == 'number' then
		return
	end
	for i = fromIndex, #args do
		local root = args[i]
		if type(root) == "table" then
			local temp = {
				"----------------printTable start----------------------------\n",
				tostring(root).."={\n",
			}
			local function table2String(t, depth)
				if type(depth) == "number" then 
					depth = depth + 1
					if depth >= 5 then
						return
					end
				else
					depth = 1
				end
				local indent = ""
				for i=1, depth do
					indent = indent .. "\t"
				end

				for k, v in pairs(t) do
					local key = tostring(k)
					local typeV = type(v)
					if typeV == "table" then
						table.insert(temp, indent..key.."={\n")
						table2String(v, depth)
						table.insert(temp, indent.."},\n")
					elseif typeV == "string" then
						table.insert(temp, string.format("%s%s=\"%s\",\n", indent, key, tostring(v)))
					else
						table.insert(temp, string.format("%s%s=%s,\n", indent, key, tostring(v)))
					end
				end
			end
			table2String(root)
			table.insert(temp, "}\n-----------------------------------printTable end------------------------------")
			
			if fromIndex == 2 then
				print(args[1], table.concat(temp))
			else
				print(table.concat(temp))
			end
			
		else
			if fromIndex == 2 then
				print(args[1], tostring(root))
			else
				print(tostring(root))
			end
			
		end
	end
end

function Utils.serialize(obj)  
    local lua = ""  
    local t = type(obj)  
    if t == "number" then  
        lua = lua .. obj  
    elseif t == "boolean" then  
        lua = lua .. tostring(obj)  
    elseif t == "string" then  
        lua = lua .. string.format("%q", obj)  
    elseif t == "table" then  
        lua = lua .. "{"  
    for k, v in pairs(obj) do  
        lua = lua .. "[" .. Utils.serialize(k) .. "]=" .. Utils.serialize(v) .. ","  
    end  
    local metatable = getmetatable(obj)  
        if metatable ~= nil and type(metatable.__index) == "table" then  
        for k, v in pairs(metatable.__index) do  
            lua = lua .. "[" .. Utils.serialize(k) .. "]=" .. Utils.serialize(v) .. ","  
        end  
    end  
        lua = lua .. "}"  
    elseif t == "nil" then  
        return nil  
    else  
        error("can not serialize a " .. t .. " type.")  
    end  
    return lua  
end  
  
function Utils.unserialize(lua)  
    local t = type(lua)  
    if t == "nil" or lua == "" then  
        return nil  
    elseif t == "number" or t == "string" or t == "boolean" then  
        lua = tostring(lua)  
    else  
        error("can not unserialize a " .. t .. " type.")  
    end  
    lua = "return " .. lua  
    local func = loadstring(lua)  
    if func == nil then  
        return nil  
    end  
    return func()  
end 
function Utils.saveDate(obj)  
    local lua = ""  
    local t = type(obj)  
    if t == "number" then  
        lua = lua .. obj  
    elseif t == "boolean" then  
        lua = lua .. tostring(obj)  
    elseif t == "string" then  
        lua = lua .. string.format("%q", obj)  
    elseif t == "table" then  
        lua = lua .. "{"  
    for k, v in pairs(obj) do  
        lua = lua .. "[" .. Utils.serialize(k) .. "]=" .. Utils.serialize(v) .. ","  
    end  
    local metatable = getmetatable(obj)  
        if metatable ~= nil and type(metatable.__index) == "table" then  
        for k, v in pairs(metatable.__index) do  
            lua = lua .. "[" .. Utils.serialize(k) .. "]=" .. Utils.serialize(v) .. ","  
        end  
    end  
        lua = "return " .. lua .. "}"
    elseif t == "nil" then  
        return nil  
    else  
        error("can not serialize a " .. t .. " type.")  
    end  
    return lua  
end

function Utils.getAllConfig(configType)
	if _G[configType] then
		return _G[configType]
	end
	local str = "src/config/" .. configType
	local c = require(str)
	if c == true then
		return _G[configType]
	end
	return nil
end

function Utils.showCenterTip(text)
	if self.panel then
    	self.panel:stopAllActions()
    else
    	self.panel = cc.LayerColor:create(cc.c4b(0, 0, 255, 255))
    	self.tipText = cc.Label:createWithTTF("", "simsun.ttf", 28)
    	self.panel:addChild(self.tipText)
    	if display.getRunningScene() then
            display.getRunningScene():addChild(self.panel, Const.Layer.max)
        else
        	return
        end
    end
	
	self.tipText:setString(text)
	self.panel:setPosition(display.cx, display.cy + 50)
	
	local s = self.tipText:getContentSize()
	s.width = s.width + 50
	s.height = self.panel:getContentSize().height
	self.panel:setContentSize(s)
	self.tipText:setPosition(s.width / 2, s.height / 2)
	
	self.panel:setScale(0, 0)
    
	local move = cc.MoveTo:create(0.2, display.center)
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