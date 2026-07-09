local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Utils = require(Modules.AvatarExperience.AvatarEditor.Utils)

require(Modules.AvatarExperience.Common.Reducers.AvatarExperience)

local function selectButtonSliderValue(p1, s1: string) -- line: 12
	-- upvalues: Utils (copy)
	local selectedBodyPartIndex = p1.AvatarEditor.BodyColorPickerSettings.selectedBodyPartIndex
	local rangeIdToBodyPartsToSliderAndColor3Values = p1.AvatarEditor.BodyColorPickerSettings.rangeIdToBodyPartsToSliderAndColor3Values

	return Utils.getSliderValueForRangeIdAndBodyPartIndex(s1, selectedBodyPartIndex, rangeIdToBodyPartsToSliderAndColor3Values)
end

return selectButtonSliderValue
