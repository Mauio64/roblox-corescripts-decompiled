local function foldLeft(p1, p2, p3) -- line: 4
	for i = 1, #p1 do
		p3 = p2(p3, p1[i], i)
	end

	return p3
end

return foldLeft
