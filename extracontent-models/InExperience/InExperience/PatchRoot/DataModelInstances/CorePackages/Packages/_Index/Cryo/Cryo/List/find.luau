local function find(p1, p2) -- line: 5
	for i = 1, #p1 do
		if p2 == p1[i] then
			return i
		end
	end

	return nil
end

return find
