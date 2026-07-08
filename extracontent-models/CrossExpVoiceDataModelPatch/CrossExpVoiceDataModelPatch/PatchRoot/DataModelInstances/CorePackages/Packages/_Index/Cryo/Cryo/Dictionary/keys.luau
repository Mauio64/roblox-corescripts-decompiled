local function keys(p1) -- line: 4
	local t1 = {}
	local n1 = 1

	for k in pairs(p1) do
		t1[n1] = k
		n1 += 1
	end

	return t1
end

return keys
