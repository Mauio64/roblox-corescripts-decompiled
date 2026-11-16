local AvatarExperienceProfilePictureEditor = script:FindFirstAncestor("AvatarExperienceProfilePictureEditor")
local parent = AvatarExperienceProfilePictureEditor.Parent

local AmpUpsell = require(parent.AmpUpsell)
local AmpApiProvider = AmpUpsell.AmpApiProvider
local AmpUpsell2 = require(parent.AmpUpsell)
local AccessResponseEnum = AmpUpsell2.AmpEnums.AccessResponseEnum
local ProfileFrameAmpConstants = require(AvatarExperienceProfilePictureEditor.Common.ProfileFrameAmpConstants)

local function getProfileFrameAmpAccess()
	local access = AmpApiProvider.upsellFeatureAccess(
		ProfileFrameAmpConstants.FEATURE_NAME,
		{},
		ProfileFrameAmpConstants.NAME_SPACE
	).access

	if access == AccessResponseEnum.Error then
		return {
			access = { granted = false, canUpsell = false },
			hasError = true
		}
	end

	if access == AccessResponseEnum.Pending then
		return {
			access = { granted = false, canUpsell = false },
			hasError = false
		}
	end

	return {
		access = {
			granted = access == AccessResponseEnum.Granted,
			canUpsell = access == AccessResponseEnum.Actionable
		},
		hasError = false
	}
end

return getProfileFrameAmpAccess
