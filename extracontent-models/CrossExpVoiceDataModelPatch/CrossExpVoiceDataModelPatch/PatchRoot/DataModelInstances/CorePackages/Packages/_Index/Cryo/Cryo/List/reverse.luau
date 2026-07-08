local function reverse(p1) -- line: 5
	local t1 = {}
	local v4 = #p1
	local v5 = v4 + 1

	for i = 1, v4 do
		t1[i] = p1[v5 - i]
	end

	return t1
end

return reverse
