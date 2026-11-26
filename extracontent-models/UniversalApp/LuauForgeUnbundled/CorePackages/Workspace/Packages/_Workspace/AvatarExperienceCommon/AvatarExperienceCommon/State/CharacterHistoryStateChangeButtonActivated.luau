return require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCommon/Rodux").makeActionCreator("CharacterHistoryStateChangeButtonActivated", function(data)
	return {
		type = "CharacterHistoryStateChangeButtonActivated",
		isUndo = data.isUndo,
		equipped = data.equipped,
		tryOn = data.tryOn
	}
end)
