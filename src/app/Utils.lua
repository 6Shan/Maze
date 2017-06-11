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

-- function Utils.setGrey(obj)
-- 	if not obj then
-- 		return
-- 	end
-- 	local node = obj:getVirtualRenderer()
-- 	node = tolua.cast(node, "ccui.Scale9Sprite")
-- 	ShaderEffect.greyScale(node:getSprite())
-- end