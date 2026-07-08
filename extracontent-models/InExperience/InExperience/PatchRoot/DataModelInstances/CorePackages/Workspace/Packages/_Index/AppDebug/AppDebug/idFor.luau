local n1 = 1
local self = setmetatable({}, {
	__mode = "k"
})

local function idFor(p1) -- line: 15
	-- upvalues: self (copy), n1 (ref)
	if p1 == nil then
		return 0
	end

	local v5 = self[p1]

	if not v5 then
		v5 = n1
		n1 += 1
		self[p1] = v5
	end

	return v5
end

return idFor
