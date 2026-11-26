local module = require("@luauforge/bundled/fCI")
require("@luauforge/bundled/dKV")

local function selectButtonSliderValue(p2, p3)
	local selectedBodyPartIndex = p2.AvatarEditor.BodyColorPickerSettings.selectedBodyPartIndex

	local rangeIdToBodyPartsToSliderAndColor3Values = p2.AvatarEditor.BodyColorPickerSettings.rangeIdToBodyPartsToSliderAndColor3Values

	return module.getSliderValueForRangeIdAndBodyPartIndex(
		p3,
		selectedBodyPartIndex,
		rangeIdToBodyPartsToSliderAndColor3Values
	)
end

return selectButtonSliderValue
