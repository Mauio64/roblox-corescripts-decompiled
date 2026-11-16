local parent = script.Parent
local parent2 = parent.Parent.Parent

require(parent2.Navigation)

local getPageNameFromRoute = require(parent.getPageNameFromRoute)

return function(p)
	if p and p.routes and p.index then
		return getPageNameFromRoute(p.routes[p.index])
	end

	return nil
end
