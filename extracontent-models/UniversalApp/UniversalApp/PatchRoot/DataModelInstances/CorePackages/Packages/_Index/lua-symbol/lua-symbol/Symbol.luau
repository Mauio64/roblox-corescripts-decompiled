return {
	named = function(p1) -- line: 15
		assert(type(p1) == "string", "Symbols must be created using a string name!")

		local v2 = newproxy(true)
		local v3 = ("Symbol(%s)"):format(p1)

		getmetatable(v2).__tostring = function() -- line: 22
			-- upvalues: v3 (copy)
			return v3
		end

		return v2
	end,
	unnamed = function() -- line: 33
		local v4 = newproxy(true)

		getmetatable(v4).__tostring = function() -- line: 36
			return "Unnamed Symbol"
		end

		return v4
	end
}
