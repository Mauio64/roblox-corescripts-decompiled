local FormValidationErrorEnum = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceFormValidation/AvatarExperienceFormValidation/FormValidationErrorEnum")

local function buildIsShorterThanOrEqualTo(p2)
	return function(p3)
		local v5 = utf8.len(p3)

		if v5 == nil or not (v5 <= p2) then
			return false, FormValidationErrorEnum.FailedIsShorterThanOrEqualTo
		end

		return true
	end
end

return buildIsShorterThanOrEqualTo
