local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Foundation = require(ProfilePlatformParent.Foundation)
local SocialUpsell = require(ProfilePlatformParent.SocialUpsell)
local ButtonVariant = Foundation.Enums.ButtonVariant
local startFacialAgeEstimation = SocialUpsell.Thunks.startFacialAgeEstimation
local SocialUpsellType = SocialUpsell.Enums.SocialUpsellType
local UpsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes
local FFlagProfilePlatformEnableUnlockChat = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableUnlockChat)

return {
	[Enums.ProfileActions.UnlockChat] = if not FFlagProfilePlatformEnableUnlockChat then nil else function(p1) -- line: 21
		-- upvalues: ButtonVariant (copy), Enums (copy), ProfileTypes (copy), EventNames (copy), startFacialAgeEstimation (copy), SocialUpsellType (copy), UpsellEntrySurfaceType (copy)
		return {
			variant = ButtonVariant.Emphasis,
			text = p1.localized[Enums.ProfileActions.UnlockChat],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 26
					-- upvalues: p1 (copy), EventNames (copy), startFacialAgeEstimation (copy), SocialUpsellType (copy), UpsellEntrySurfaceType (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.CTAButtonUnlockChat, {
						buttonSurface = p1.buttonSurface
					})
					p1.dispatch(startFacialAgeEstimation(SocialUpsellType.FacialAgeEstimation .. UpsellEntrySurfaceType.ProfileActionBar, nil, nil, UpsellEntrySurfaceType.ProfileActionBar, false))
				end
			}
		}
	end
}
