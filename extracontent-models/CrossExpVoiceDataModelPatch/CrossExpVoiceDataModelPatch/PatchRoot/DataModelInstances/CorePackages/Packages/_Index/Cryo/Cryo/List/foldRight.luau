local function foldRight(list, callback, p)
	for i = #list, 1, -1 do
		p = callback(p, list[i], i)
	end

	return p
end

return foldRight
