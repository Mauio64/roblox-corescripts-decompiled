return function(p1) -- line: 2
	local v2 = type(p1)

	return v2 == "function" or v2 == "table" and type(p1.render) == "function"
end
