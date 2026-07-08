local function foldRight(p1, p2, p3) -- line: 4
	for i = #p1, 1, -1 do
		p3 = p2(p3, p1[i], i)
	end

	return p3
end

return foldRight
