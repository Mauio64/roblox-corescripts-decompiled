local parent = script:FindFirstAncestor("ExpChatShared").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(channelName: string, isUserInitiated: boolean?)
	return { channelName = channelName, isUserInitiated = isUserInitiated }
end)
