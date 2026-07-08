return {
	new = function(s1: string?) -- line: 15
		local v2 = newproxy(true)
		local s2 = "Symbol()"

		if s1 then
			s2 = ("Symbol(%s)"):format(s1)
		end

		getmetatable(v2).__tostring = function() -- line: 23
			-- upvalues: s2 (ref)
			return s2
		end

		return v2
	end
}
