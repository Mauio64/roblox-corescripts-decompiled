local parent = script:FindFirstAncestor("UserLib").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(userId, isFriend)
	return { userId = userId, isFriend = isFriend }
end)
