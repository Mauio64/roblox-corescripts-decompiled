local invariant = require(script.Parent.Parent.utils.invariant)

return function(p1, p2) -- line: 3
	-- upvalues: invariant (copy)
	invariant(type(p1.title) ~= "function", "title cannot be defined as a function in navigation options for screen '%s'", p2.routeName)
end
