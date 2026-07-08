local function divideTransparency(p1, p2) -- line: 11
	return 1 - (1 - p1) / p2
end

return divideTransparency
