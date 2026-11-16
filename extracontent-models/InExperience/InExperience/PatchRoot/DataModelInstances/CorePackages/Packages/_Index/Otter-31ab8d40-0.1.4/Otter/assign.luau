local function assign(p, ...)
	for i = 1, select("#", ...) do
		local v = select(i, ...)

		for k, v2 in pairs(v) do
			p[k] = v2
		end
	end

	return p
end

return assign
