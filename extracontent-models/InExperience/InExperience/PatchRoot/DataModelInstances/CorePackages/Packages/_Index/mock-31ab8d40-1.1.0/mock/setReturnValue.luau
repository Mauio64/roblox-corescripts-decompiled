local symbols = require(script.Parent.symbols)

return function(p, p2)
	getmetatable(p)[symbols.ReturnValue] = { p2 }
end
