local parent = script:FindFirstAncestor("ExpChat").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(channelName: string, tabIndex: number)
	return { channelName = channelName, tabIndex = tabIndex }
end)
