local null = require(script.Parent.null)

return {
	isNillish = function(p1) -- line: 3
		-- upvalues: null (copy)
		return p1 == nil or p1 == null
	end,
	isNotNillish = function(p2) -- line: 7
		-- upvalues: null (copy)
		return p2 ~= nil and p2 ~= null
	end
}
