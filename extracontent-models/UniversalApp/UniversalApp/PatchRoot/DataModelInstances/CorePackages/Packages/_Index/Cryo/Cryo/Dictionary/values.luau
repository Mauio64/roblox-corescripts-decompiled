local function values(p1) -- line: 5
	local t1 = {}
	local n1 = 1

	for _, v in pairs(p1) do
		t1[n1] = v
		n1 += 1
	end

	return t1
end

return values
