cc.exports.GameClient = {}

function GameClient.printTable(...)
	-- if __HIDE_TEST__ then return end
	
	local args = {...}
	local fromIndex = 1

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