local function foldLeft(list, callback, p)
	for i = 1, #list do
		p = callback(p, list[i], i)
	end

	return p
end

return foldLeft
