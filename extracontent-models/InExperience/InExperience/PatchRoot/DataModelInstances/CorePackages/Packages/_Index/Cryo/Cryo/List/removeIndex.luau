local function removeIndex(p1, p2) -- line: 4
	local t1 = {}
	local n1 = 0

	for i = 1, #p1 do
		if i == p2 then
			n1 = 1
		else
			t1[i - n1] = p1[i]
		end
	end

	return t1
end

return removeIndex
