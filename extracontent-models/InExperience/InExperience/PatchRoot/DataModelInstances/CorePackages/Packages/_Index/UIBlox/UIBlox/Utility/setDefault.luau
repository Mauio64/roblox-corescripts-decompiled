local function setDefault(p1, p2) -- line: 5
	if p1 == nil then
		return p2
	end

	return p1
end

return setDefault
