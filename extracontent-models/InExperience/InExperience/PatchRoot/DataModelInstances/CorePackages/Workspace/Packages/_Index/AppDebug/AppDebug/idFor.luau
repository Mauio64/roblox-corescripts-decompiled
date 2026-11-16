local v = 1
local object = setmetatable({}, { __mode = "k" })

local function idFor(p)
	if p == nil then
		return 0
	end

	local v2 = object[p]

	if not v2 then
		v2 = v
		v += 1
		object[p] = v2
	end

	return v2
end

return idFor
