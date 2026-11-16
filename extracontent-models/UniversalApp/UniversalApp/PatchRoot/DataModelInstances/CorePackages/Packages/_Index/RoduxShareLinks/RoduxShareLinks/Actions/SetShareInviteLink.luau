local parent = script:FindFirstAncestor("RoduxShareLinks").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(shareInviteLink: string)
	return { shareInviteLink = shareInviteLink }
end)
