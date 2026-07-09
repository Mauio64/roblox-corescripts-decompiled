local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

require(Parent.AvatarExperienceCommon)

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 17
	return {
		itemId = t1.itemId,
		selectedTimedOptionIndex = t1.selectedTimedOptionIndex,
		itemType = t1.itemType
	}
end)
