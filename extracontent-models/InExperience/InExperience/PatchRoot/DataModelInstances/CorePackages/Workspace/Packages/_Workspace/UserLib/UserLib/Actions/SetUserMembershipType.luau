local parent = script:FindFirstAncestor("UserLib").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(userId, membershipType)
	return { userId = userId, membershipType = membershipType }
end)
