local parent = script:FindFirstAncestor("UserLib").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(userId, hasRobloxSubscription)
	return { userId = userId, hasRobloxSubscription = hasRobloxSubscription }
end)
