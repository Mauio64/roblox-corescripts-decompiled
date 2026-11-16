local function get(p, items, p2)
	if p == nil then
		return p2
	end

	for _, item in items do
		if type(p) ~= "table" then
			return p2
		end

		p = p[item]

		if p == nil then
			return p2
		end
	end

	return p
end

return get
