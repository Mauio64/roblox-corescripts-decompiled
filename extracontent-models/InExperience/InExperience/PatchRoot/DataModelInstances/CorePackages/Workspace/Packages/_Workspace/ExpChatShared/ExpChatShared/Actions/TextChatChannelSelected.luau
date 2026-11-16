local parent = script:FindFirstAncestor("ExpChatShared").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(channelName: string, shouldReorderTabs: boolean)
	return { channelName = channelName, shouldReorderTabs = shouldReorderTabs }
end)
