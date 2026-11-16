local ampApiProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AmpUpsell").AmpApiProvider
local accessResponseEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceProfilePictureEditor/AmpUpsell").AmpEnums.AccessResponseEnum
local ProfileFrameAmpConstants = require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceProfilePictureEditor/AvatarExperienceProfilePictureEditor/Common/ProfileFrameAmpConstants")

local function getProfileFrameAmpAccess()
	local access = ampApiProvider.upsellFeatureAccess(ProfileFrameAmpConstants.FEATURE_NAME, {}, ProfileFrameAmpConstants.NAME_SPACE).access

	if access == accessResponseEnum.Error then
		return {
			access = { granted = false, canUpsell = false },
			hasError = true
		}
	end

	if access == accessResponseEnum.Pending then
		return {
			access = { granted = false, canUpsell = false },
			hasError = false
		}
	end

	return {
		access = {
			granted = access == accessResponseEnum.Granted,
			canUpsell = access == accessResponseEnum.Actionable
		},
		hasError = false
	}
end

return getProfileFrameAmpAccess
