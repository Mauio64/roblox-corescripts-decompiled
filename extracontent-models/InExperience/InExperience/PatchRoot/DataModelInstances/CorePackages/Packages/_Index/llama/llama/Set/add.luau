local function add(p1, ...) -- line: 2
	local t1 = {}

	for k, _ in pairs(p1) do
		t1[k] = true
	end

	for i = 1, select("#", ...) do
		t1[select(i, ...)] = true
	end

	return t1
end

return add
