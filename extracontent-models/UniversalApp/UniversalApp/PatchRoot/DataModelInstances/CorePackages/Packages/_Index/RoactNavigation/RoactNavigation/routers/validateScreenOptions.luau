local invariant = require(script.Parent.Parent.utils.invariant)

return function(p, p2)
	invariant(
		type(p.title) ~= "function",
		"title cannot be defined as a function in navigation options for screen '%s'",
		p2.routeName
	)
end
