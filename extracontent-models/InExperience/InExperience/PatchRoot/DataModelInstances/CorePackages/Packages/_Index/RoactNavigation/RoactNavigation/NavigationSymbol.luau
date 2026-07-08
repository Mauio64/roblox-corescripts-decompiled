return function(p1) -- line: 4
	assert(type(p1) == "string", "Symbols must be created using a string name!")

	local v2 = newproxy(true)

	getmetatable(v2).__tostring = function() -- line: 10
		-- upvalues: p1 (copy)
		return p1
	end

	return v2
end
