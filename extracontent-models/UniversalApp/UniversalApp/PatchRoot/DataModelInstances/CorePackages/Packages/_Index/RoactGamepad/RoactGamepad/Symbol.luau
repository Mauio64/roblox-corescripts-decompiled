return {
	named = function(value)
		assert(type(value) == "string", "Symbols must be created using a string name!")

		local v = newproxy(true)

		local formatted = ("Symbol(%s)"):format(value)

		getmetatable(v).__tostring = function()
			return formatted
		end

		return v
	end
}
