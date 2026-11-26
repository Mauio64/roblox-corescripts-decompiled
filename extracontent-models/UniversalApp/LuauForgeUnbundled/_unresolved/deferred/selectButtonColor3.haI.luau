local module = require("@luauforge/bundled/fCI")
require("@luauforge/bundled/dKV")

local function selectButtonColor3(p2, p3)
	local selectedBodyPartIndex = p2.AvatarEditor.BodyColorPickerSettings.selectedBodyPartIndex

	local rangeIdToBodyPartsToSliderAndColor3Values = p2.AvatarEditor.BodyColorPickerSettings.rangeIdToBodyPartsToSliderAndColor3Values
	local defaultBodyColorRanges = p2.AvatarEditor.DefaultBodyColorRanges

	return module.getColor3ForRangeIdAndBodyPartIndex(
		p3,
		selectedBodyPartIndex,
		rangeIdToBodyPartsToSliderAndColor3Values,
		defaultBodyColorRanges
	)
end

return selectButtonColor3
