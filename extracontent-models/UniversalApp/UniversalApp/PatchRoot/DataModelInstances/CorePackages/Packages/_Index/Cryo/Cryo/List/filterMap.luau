local function filterMap(p1, p2) -- line: 7
	local t1 = {}
	local n1 = 1

	for i = 1, #p1 do
		local v7 = p2(p1[i], i)

		if v7 ~= nil then
			t1[n1] = v7
			n1 += 1
		end
	end

	return t1
end

return filterMap
