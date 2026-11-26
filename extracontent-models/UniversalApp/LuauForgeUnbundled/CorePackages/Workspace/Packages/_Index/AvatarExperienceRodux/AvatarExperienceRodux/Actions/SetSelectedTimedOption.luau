local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/Rodux")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceRodux/AvatarExperienceModel")

return Rodux.makeActionCreator("SetSelectedTimedOption", function(p2, p3, p4)
	return { itemId = p2, selectedTimedOptionIndex = p3, itemType = p4 }
end)
