local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent

require(ParentParent.Navigation)

local getPageNameFromRoute = require(scriptParent.getPageNameFromRoute)

return function(p1) -- line: 11
	-- upvalues: getPageNameFromRoute (copy)
	if not p1 or (not p1.routes or not p1.routes[1]) then
		return nil
	end

	return getPageNameFromRoute(p1.routes[1])
end
