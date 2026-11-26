local FormValidationErrorEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceFormValidation/AvatarExperienceFormValidation/FormValidationErrorEnum")

local function isNotNull(p2)
	if p2 == nil then
		return false, FormValidationErrorEnum.FailedIsNotNull
	end

	return true
end

return isNotNull
