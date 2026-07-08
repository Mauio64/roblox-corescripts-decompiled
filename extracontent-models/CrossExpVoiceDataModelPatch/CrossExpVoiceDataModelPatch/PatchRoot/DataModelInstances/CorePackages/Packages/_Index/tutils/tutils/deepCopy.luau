local function deepCopy(p1, p2) -- line: 9
	-- upvalues: deepCopy (copy)
	if type(p1) ~= "table" then
		return p1
	end

	if p2 and p2[p1] then
		return p2[p1]
	end

	local v4 = p2 or {}
	local self = setmetatable({}, (getmetatable(p1)))

	v4[p1] = self

	for k, v in pairs(p1) do
		self[deepCopy(k, v4)] = deepCopy(v, v4)
	end

	return self
end

return deepCopy
