local parent = script:FindFirstAncestor("RoduxSquads").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(notificationId: string)
	return {
		payload = { notificationId = notificationId }
	}
end)
