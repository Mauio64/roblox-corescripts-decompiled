local function parseBooleanString(s1: string?) -- line: 1
	if s1 == nil then
		return nil
	end

	return s1 == "true" or (s1 == "True" or s1 == "1")
end

return parseBooleanString
