local parent = script:FindFirstAncestor("ExpChatShared").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(channelName: string, textChannel)
	return { channelName = channelName, textChannel = textChannel }
end)
