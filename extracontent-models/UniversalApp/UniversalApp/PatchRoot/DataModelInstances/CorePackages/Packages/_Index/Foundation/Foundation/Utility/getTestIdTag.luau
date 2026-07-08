local function getTestIdTag(s1: string?, s2: string?) -- line: 9
	if s1 == nil then
		return nil
	end

	if s2 then
		return `data-testid={ s1 }--{ s2 }`
	end

	return `data-testid={ s1 }`
end

return getTestIdTag
