local parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent
local Rodux = require(parent.Rodux)
require(parent.AvatarExperienceModel)

return Rodux.makeActionCreator(script.Name, function(itemId: string, selectedTimedOptionIndex: number?, itemType)
	return {
		itemId = itemId,
		selectedTimedOptionIndex = selectedTimedOptionIndex,
		itemType = itemType
	}
end)
