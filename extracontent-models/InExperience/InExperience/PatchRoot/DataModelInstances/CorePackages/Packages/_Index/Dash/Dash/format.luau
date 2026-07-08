local scriptParent = script.Parent
local formatValue = require(scriptParent.formatValue)
local splitOn = require(scriptParent.splitOn)
local startsWith = require(scriptParent.startsWith)
local concat = table.concat
local insert = table.insert

local function format(s1: string, ...) -- line: 43
	-- upvalues: splitOn (copy), insert (copy), startsWith (copy), formatValue (copy), concat (copy)
	local t1 = { ... }
	local n1 = 1
	local v11, v12 = splitOn(s1, "{[^{}]*}")
	local t2 = {}

	for v14, v15 in v11 do
		insert(t2, (v15:gsub("{{", "{"):gsub("}}", "}")))

		local v16 = v12[v14] and v12[v14]:sub(2, -2)

		if v16 then
			local v17 = v15:gmatch("{+$")()

			if not v17 or #v17 % 2 ~= 1 then
				local v18 = splitOn(v16, ":")
				local v19 = startsWith(v18[1], "#")
				local v20 = v19 and v18[1]:sub(2) or v18[1]
				local num = tonumber(v20)
				local v22 = v18[2]
				local s2 = "nil"

				if num then
					s2 = t1[num]
				elseif v20:len() > 0 then
					local v24 = t1[1] and t1[1][v20]

					if v24 ~= nil then
						s2 = v24
					end
				else
					s2 = t1[n1]
					n1 += 1
				end

				if v19 then
					s2 = #s2
				end

				insert(t2, formatValue(s2, v22 or ""))
			else
				insert(t2, v16)
			end
		end
	end

	return concat(t2, "")
end

return format
