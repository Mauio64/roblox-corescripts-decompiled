local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent
require(parent.AvatarExperienceModel)
local Rodux = require(parent.Rodux)

return Rodux.makeActionCreator(script.Name, function(data)
	return {
		itemId = data.itemId,
		selectedTimedOptionIndex = data.selectedTimedOptionIndex,
		itemType = data.itemType
	}
end)
