local equalObjects = require(script.Parent.Parent.equalObjects)

local function equals(...): boolean
	if equalObjects(...) then
		return true
	end

	local v = select("#", ...)

	for i = 1, v do
		local v2 = select(i, ...)

		for j = 1, v do
			if j == i then
				continue
			end

			local v3 = select(j, ...)

			for k, v4 in pairs(v2) do
				if v4 ~= v3[k] then
					return false
				end
			end
		end
	end

	return true
end

return equals
