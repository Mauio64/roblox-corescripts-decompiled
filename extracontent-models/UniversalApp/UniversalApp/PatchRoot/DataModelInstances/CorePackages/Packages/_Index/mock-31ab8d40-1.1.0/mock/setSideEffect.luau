local symbols = require(script.Parent.symbols)

return function(p, p2)
	getmetatable(p)[symbols.SideEffect] = p2 and { value = p2, calls = 0 } or nil
end
