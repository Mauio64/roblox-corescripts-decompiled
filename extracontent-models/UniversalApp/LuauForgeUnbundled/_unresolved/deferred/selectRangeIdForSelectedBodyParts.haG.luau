require("@luauforge/bundled/dKT")

local module = require("@luauforge/deferred/haH")

local function selectRangeIdForSelectedBodyParts(p2)
	return module(p2, p2.AvatarExperience.AvatarEditor.BodyColorPickerSettings.selectedBodyPartIndex)
end

return selectRangeIdForSelectedBodyParts
