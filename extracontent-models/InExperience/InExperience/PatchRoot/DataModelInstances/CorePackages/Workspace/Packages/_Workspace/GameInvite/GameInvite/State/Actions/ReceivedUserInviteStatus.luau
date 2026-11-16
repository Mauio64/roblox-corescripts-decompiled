local parent = script:FindFirstAncestor("GameInvite").Parent

local Rodux = require(parent.Rodux)
return Rodux.makeActionCreator(script.Name, function(p, inviteStatus)
	return { userId = tostring(p), inviteStatus = inviteStatus }
end)
