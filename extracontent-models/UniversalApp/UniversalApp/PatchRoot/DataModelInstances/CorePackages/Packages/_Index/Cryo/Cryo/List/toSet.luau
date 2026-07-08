local function toSet(p1) -- line: 6
	local t1 = {}

	for i = 1, #p1 do
		t1[p1[i]] = true
	end

	return t1
end

return toSet
