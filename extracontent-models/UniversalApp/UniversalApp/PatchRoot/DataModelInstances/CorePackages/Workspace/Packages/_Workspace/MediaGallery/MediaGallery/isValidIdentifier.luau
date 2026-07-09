local function isValidIdentifier(s1: string?) -- line: 1
	return s1 ~= nil and (s1 ~= "" and s1 ~= "0")
end

return isValidIdentifier
