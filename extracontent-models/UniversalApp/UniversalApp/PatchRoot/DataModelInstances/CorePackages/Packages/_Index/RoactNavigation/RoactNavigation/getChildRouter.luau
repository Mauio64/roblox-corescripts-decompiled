local invariant = require(script.Parent.utils.invariant)

return function(p1, p2) -- line: 4
	-- upvalues: invariant (copy)
	if p1.childRouters and p1.childRouters[p2] then
		return p1.childRouters[p2]
	end

	invariant(type(p1.getComponentForRouteName) == "function", "router.getComponentForRouteName must be a function if no child routers are specified")

	local v4 = p1.getComponentForRouteName(p2)

	if type(v4) == "table" then
		return v4.router
	end

	return nil
end
