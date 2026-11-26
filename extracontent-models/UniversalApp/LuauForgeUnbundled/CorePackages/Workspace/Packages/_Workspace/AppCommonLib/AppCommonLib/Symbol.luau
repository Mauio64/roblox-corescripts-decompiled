return {
	named = function(value)
		assert(type(value) == "string", "Symbols must be created using a string name!")

		local v5 = newproxy(true)

		local formatted = ("Symbol(%s)"):format(value)

		getmetatable(v5).__tostring = function()
			return formatted
		end

		return v5
	end,
	unnamed = function()
		local v5 = newproxy(true)

		getmetatable(v5).__tostring = function(): string
			return "Unnamed Symbol"
		end

		return v5
	end
}
