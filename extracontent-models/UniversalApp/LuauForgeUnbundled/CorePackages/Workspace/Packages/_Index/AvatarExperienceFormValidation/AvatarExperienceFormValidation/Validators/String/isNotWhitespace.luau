local FormValidationErrorEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceFormValidation/AvatarExperienceFormValidation/FormValidationErrorEnum")

local function isNotWhitespace(value)
	if string.match(value, "%S") == nil then
		return false, FormValidationErrorEnum.FailedIsNotWhitespace
	end

	return true
end

return isNotWhitespace
