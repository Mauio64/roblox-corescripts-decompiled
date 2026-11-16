local parent = script:FindFirstAncestor("AuthenticationStatus").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(status)
	return { status = status }
end)
