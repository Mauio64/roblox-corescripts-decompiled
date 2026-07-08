local symbols = require(script.Parent.symbols)

return function(p1) -- line: 3
	-- upvalues: symbols (copy)
	assert(type(p1) == "function", "Mock Error: Mock.predicate must be given a function")

	return (setmetatable({
		[symbols.isPredicate] = true,
		predicate = p1
	}, {
		__tostring = function() -- line: 10
			return "<Predicate>"
		end
	}))
end
