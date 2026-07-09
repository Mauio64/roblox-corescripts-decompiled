local u1 = nil

return {
	getUrl = function() -- line: 4
		-- upvalues: u1 (ref)
		return u1
	end,
	setUrl = function(s1: string?) -- line: 8
		-- upvalues: u1 (ref)
		u1 = s1
	end
}
