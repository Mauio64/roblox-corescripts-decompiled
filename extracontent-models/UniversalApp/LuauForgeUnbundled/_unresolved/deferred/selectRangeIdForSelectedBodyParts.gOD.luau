require("@luauforge/bundled/dHK")

local module = require("@luauforge/deferred/gOE")

local function selectRangeIdForSelectedBodyParts(p2)
	return module(p2, p2.AvatarExperience.AvatarEditor.BodyColorPickerSettings.selectedBodyPartIndex)
end

return selectRangeIdForSelectedBodyParts
