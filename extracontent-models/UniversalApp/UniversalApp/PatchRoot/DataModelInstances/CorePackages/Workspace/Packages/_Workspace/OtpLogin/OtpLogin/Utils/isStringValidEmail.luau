return function(s1: string?) -- line: 1
	if not s1 or s1 == "" then
		return false
	end

	assert(s1, "")

	return string.find(s1, "^.+@.+%..+$") ~= nil
end
