require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceModel")
return require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Rodux").makeActionCreator("SetSelectedTimedOption", function(data)
	return {
		itemId = data.itemId,
		selectedTimedOptionIndex = data.selectedTimedOptionIndex,
		itemType = data.itemType
	}
end)
