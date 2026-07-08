local function union(...) -- line: 2
	local t1 = {}

	for i = 1, select("#", ...) do
		for k, _ in pairs(select(i, ...)) do
			t1[k] = true
		end
	end

	return t1
end

return union
