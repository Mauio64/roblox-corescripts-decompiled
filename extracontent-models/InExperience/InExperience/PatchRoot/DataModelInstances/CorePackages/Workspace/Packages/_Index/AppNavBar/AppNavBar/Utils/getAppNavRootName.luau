local parent = script.Parent
local parent2 = parent.Parent.Parent

require(parent2.Navigation)

local getPageNameFromRoute = require(parent.getPageNameFromRoute)

return function(p)
	if p and p.routes and p.routes[1] then
		return getPageNameFromRoute(p.routes[1])
	end

	return nil
end
