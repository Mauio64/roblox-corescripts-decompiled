local function assign(p1, ...) -- line: 1
	for i = 1, select("#", ...) do
		local v4 = select(i, ...)

		for k, v in pairs(v4) do
			p1[k] = v
		end
	end

	return p1
end

return assign
