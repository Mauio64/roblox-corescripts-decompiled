local function normalizeScreenSizeForWire(s1: string) -- line: 24
	if #s1 == 0 then
		return s1
	end

	return string.lower((string.sub(s1, 1, 1))) .. string.sub(s1, 2)
end

return normalizeScreenSizeForWire
