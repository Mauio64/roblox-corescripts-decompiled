require("@game/CorePackages/Workspace/Packages/_Workspace/AppNavBar/Navigation")

local getPageNameFromRoute = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Utils/getPageNameFromRoute")

return function(p2)
	if p2 and p2.routes and p2.routes[1] then
		return getPageNameFromRoute(p2.routes[1])
	end

	return nil
end
