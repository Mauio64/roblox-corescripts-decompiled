local function isValidEmail(s1: string?) -- line: 5
	if s1 == nil or s1 == "" then
		return false
	end

	return string.match(s1, "^.+@.+%..+$") ~= nil
end

return isValidEmail
