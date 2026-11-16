local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)
local SocialUpsell = require(parent.SocialUpsell)

local ButtonVariant = Foundation.Enums.ButtonVariant
local startFacialAgeEstimation = SocialUpsell.Thunks.startFacialAgeEstimation
local SocialUpsellType = SocialUpsell.Enums.SocialUpsellType
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.UnlockChat] = function(data)
		return {
			variant = ButtonVariant.Emphasis,
			text = data.localized[Enums.ProfileActions.UnlockChat],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonUnlockChat, {
						buttonSurface = data.buttonSurface
					})

					data.dispatch(startFacialAgeEstimation(
						SocialUpsellType.FacialAgeEstimation .. UpsellEntrySurfaceType.ProfileActionBar,
						nil,
						nil,
						UpsellEntrySurfaceType.ProfileActionBar,
						false
					))
				end
			}
		}
	end
}
