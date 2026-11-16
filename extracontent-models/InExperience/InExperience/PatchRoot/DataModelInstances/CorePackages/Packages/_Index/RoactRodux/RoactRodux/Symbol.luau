local Symbol = {}

function Symbol.named(value)
	assert(type(value) == "string", "Symbols must be created using a string name!")

	local v = newproxy(true)

	local formatted = ("Symbol(%s)"):format(value)

	getmetatable(v).__tostring = function()
		return formatted
	end

	return v
end

function Symbol.unnamed()
	local v = newproxy(true)

	getmetatable(v).__tostring = function(): string
		return "Unnamed Symbol"
	end

	return v
end

return Symbol
