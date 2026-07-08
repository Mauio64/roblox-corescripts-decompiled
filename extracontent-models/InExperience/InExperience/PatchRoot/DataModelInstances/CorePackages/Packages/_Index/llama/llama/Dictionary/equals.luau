local equalObjects = require(script.Parent.Parent.equalObjects)

local function equals(...) -- line: 4
	-- upvalues: equalObjects (copy)
	if equalObjects(...) then
		return true
	end

	local v3 = select("#", ...)

	for i = 1, v3 do
		local v5 = select(i, ...)

		for j = 1, v3 do
			if j ~= i then
				local v7 = select(j, ...)

				for k, v in pairs(v5) do
					if v ~= v7[k] then
						return false
					end
				end
			end
		end
	end

	return true
end

return equals
