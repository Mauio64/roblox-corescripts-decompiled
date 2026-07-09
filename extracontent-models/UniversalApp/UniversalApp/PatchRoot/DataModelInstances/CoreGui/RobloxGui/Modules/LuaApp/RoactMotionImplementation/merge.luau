return function(...) -- line: 5
	local t1 = {}

	for i = 1, select("#", ...) do
		for k, v in pairs(select(i, ...)) do
			t1[k] = v
		end
	end

	return t1
end
