return function(p1) -- line: 4
	local n1 = 0

	for _ in pairs(p1) do
		n1 += 1
	end

	return n1
end
