local function filter(p1, p2) -- line: 5
	local t1 = {}
	local n1 = 1

	for i = 1, #p1 do
		local v7 = p1[i]

		if p2(v7, i) then
			t1[n1] = v7
			n1 += 1
		end
	end

	return t1
end

return filter
