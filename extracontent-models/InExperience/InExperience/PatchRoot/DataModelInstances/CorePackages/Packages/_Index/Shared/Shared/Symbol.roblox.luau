return {
	named = function(value)
		assert(type(value) == "string", "Symbols must be created using a string name!")

		local v = newproxy(true)

		local v2 = string.format("Symbol(%s)", value)

		getmetatable(v).__tostring = function()
			return v2
		end

		return v
	end
}
