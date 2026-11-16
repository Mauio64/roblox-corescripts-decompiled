local parent = script:FindFirstAncestor("UserLib").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(users)
	return { users = users }
end)
