local parent = script.Parent
local formatValue = require(parent.formatValue)
local splitOn = require(parent.splitOn)
local startsWith = require(parent.startsWith)

local concat = table.concat
local insert = table.insert

local function format(p: string, ...)
	local v, v2 = splitOn(p, "{[^{}]*}")
	local v3 = {}
	local v4 = { ... }
	local v5 = 1

	for k, v6 in v do
		insert(v3, (v6:gsub("{{", "{"):gsub("}}", "}")))
		local v7 = v2[k] and v2[k]:sub(2, -2)

		if not v7 then
			continue
		end

		local v8 = v6:gmatch("{+$")()

		if v8 and #v8 % 2 == 1 then
			insert(v3, v7)
		else
			local v9 = splitOn(v7, ":")
			local v10 = startsWith(v9[1], "#")
			local v11 = v10 and v9[1]:sub(2) or v9[1]
			local v12 = tonumber(v11)
			local v13 = v9[2]
			local v14 = "nil"

			if v12 then
				v14 = v4[v12]
			elseif v11:len() > 0 then
				local v15 = v4[1] and v4[1][v11]

				if v15 ~= nil then
					v14 = v15
				end
			else
				v14 = v4[v5]
				v5 += 1
			end

			insert(v3, formatValue(v10 and #v14 or v14, v13 or ""))
		end
	end

	return concat(v3, "")
end

return format
