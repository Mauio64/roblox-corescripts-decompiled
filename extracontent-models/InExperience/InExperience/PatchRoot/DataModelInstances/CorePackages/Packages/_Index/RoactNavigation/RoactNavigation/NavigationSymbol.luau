return function(value)
	assert(type(value) == "string", "Symbols must be created using a string name!")

	local v = newproxy(true)

	getmetatable(v).__tostring = function()
		return value
	end

	return v
end
