local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(channelName: string, hasUnreadMessages: boolean)
	return { channelName = channelName, hasUnreadMessages = hasUnreadMessages }
end)
