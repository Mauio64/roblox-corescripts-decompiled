local function removeValue(p1, p2) -- line: 4
	local t1 = {}
	local n1 = 1

	for i = 1, #p1 do
		if p2 ~= p1[i] then
			t1[n1] = p1[i]
			n1 += 1
		end
	end

	return t1
end

return removeValue
