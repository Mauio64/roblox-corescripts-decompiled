local function getOrSet(p, p2, callback)
	if p[p2] == nil then
		p[p2] = callback(p, p2)
	end

	return p[p2]
end

return getOrSet
