local function divideTransparency(p, p2)
	return 1 - (1 - p) / p2
end

return divideTransparency
