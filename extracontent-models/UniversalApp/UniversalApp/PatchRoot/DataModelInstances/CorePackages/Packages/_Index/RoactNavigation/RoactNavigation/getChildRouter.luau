local invariant = require(script.Parent.utils.invariant)

return function(p, p2)
	if p.childRouters and p.childRouters[p2] then
		return p.childRouters[p2]
	end

	invariant(
		type(p.getComponentForRouteName) == "function",
		"router.getComponentForRouteName must be a function if no child routers are specified"
	)

	local componentForRouteName = p.getComponentForRouteName(p2)

	if type(componentForRouteName) == "table" then
		return componentForRouteName.router
	end

	return nil
end
