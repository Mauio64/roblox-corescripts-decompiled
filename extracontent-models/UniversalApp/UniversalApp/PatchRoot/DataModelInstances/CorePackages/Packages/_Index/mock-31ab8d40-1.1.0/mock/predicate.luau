local symbols = require(script.Parent.symbols)

return function(predicate)
	assert(type(predicate) == "function", "Mock Error: Mock.predicate must be given a function")

	local v = { [symbols.isPredicate] = true, predicate = predicate }
	return (setmetatable(v, {
		__tostring = function(): string
			return "<Predicate>"
		end
	}))
end
