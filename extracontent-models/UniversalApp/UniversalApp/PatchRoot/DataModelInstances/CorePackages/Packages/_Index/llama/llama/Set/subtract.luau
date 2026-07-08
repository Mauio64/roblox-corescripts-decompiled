local function subtract(p1, ...) -- line: 2
	local t1 = {}

	for k, _ in pairs(p1) do
		t1[k] = true
	end

	for i = 1, select("#", ...) do
		t1[select(i, ...)] = nil
	end

	return t1
end

return subtract
