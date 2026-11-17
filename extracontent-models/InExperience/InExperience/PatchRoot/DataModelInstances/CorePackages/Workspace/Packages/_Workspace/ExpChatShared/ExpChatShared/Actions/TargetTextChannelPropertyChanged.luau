local parent = script:FindFirstAncestor("ExpChatShared").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(textChannel, shouldReorderTabs: boolean, isUserInitiated: boolean?)
	return {
		textChannel = textChannel,
		shouldReorderTabs = shouldReorderTabs,
		isUserInitiated = isUserInitiated
	}
end)
