local parent = script:FindFirstAncestor("ExpChatShared").Parent
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(data)
	return {
		team = data.team,
		isChatCoreGuiEnabled = data.isChatCoreGuiEnabled == nil or data.isChatCoreGuiEnabled,
		isTouchEnabled = data.isTouchEnabled,
		isGamepadEnabled = data.isGamepadEnabled
	}
end)
