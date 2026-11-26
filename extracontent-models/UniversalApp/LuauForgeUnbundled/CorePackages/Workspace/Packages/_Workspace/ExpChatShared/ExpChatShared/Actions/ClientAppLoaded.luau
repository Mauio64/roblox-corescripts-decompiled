return require("@game/CorePackages/Workspace/Packages/_Workspace/ExpChatShared/Rodux").makeActionCreator("ClientAppLoaded", function(data)
	return {
		team = data.team,
		isChatCoreGuiEnabled = data.isChatCoreGuiEnabled == nil or data.isChatCoreGuiEnabled,
		isTouchEnabled = data.isTouchEnabled,
		isGamepadEnabled = data.isGamepadEnabled
	}
end)
