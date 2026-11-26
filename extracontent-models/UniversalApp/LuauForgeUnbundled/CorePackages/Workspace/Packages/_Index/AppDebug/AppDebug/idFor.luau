local v5 = 1
local object = setmetatable({}, { __mode = "k" })

local function idFor(p2)
	if p2 == nil then
		return 0
	end

	local v6 = object[p2]

	if not v6 then
		v6 = v5
		v5 += 1
		object[p2] = v6
	end

	return v6
end

return idFor
