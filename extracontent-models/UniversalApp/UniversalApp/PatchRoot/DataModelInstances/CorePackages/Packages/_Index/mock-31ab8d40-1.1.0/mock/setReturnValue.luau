local symbols = require(script.Parent.symbols)

return function(p1, p2) -- line: 3
	-- upvalues: symbols (copy)
	getmetatable(p1)[symbols.ReturnValue] = { p2 }
end
