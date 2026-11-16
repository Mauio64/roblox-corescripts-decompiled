return function(value: string?): boolean
	if not value or value == "" then
		return false
	end

	assert(value, "")

	return string.find(value, "^.+@.+%..+$") ~= nil
end
