return {
	named = function(p1) -- line: 16
		assert(type(p1) == "string", "Symbols must be created using a string name!")

		local v2 = newproxy(true)
		local v3 = ("Symbol(%s)"):format(p1)

		getmetatable(v2).__tostring = function() -- line: 23
			-- upvalues: v3 (copy)
			return v3
		end

		return v2
	end
}
