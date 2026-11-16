local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local SocialUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialUpsell")

local buttonVariant = Foundation.Enums.ButtonVariant
local startFacialAgeEstimation = SocialUpsell.Thunks.startFacialAgeEstimation
local socialUpsellType = SocialUpsell.Enums.SocialUpsellType
local upsellEntrySurfaceType = SocialUpsell.Analytics.Enum.UpsellEntrySurfaceType

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.UnlockChat] = function(data)
		return {
			variant = buttonVariant.Emphasis,
			text = data.localized[Enums.ProfileActions.UnlockChat],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonUnlockChat, {
						buttonSurface = data.buttonSurface
					})

					data.dispatch(startFacialAgeEstimation(
						socialUpsellType.FacialAgeEstimation .. upsellEntrySurfaceType.ProfileActionBar,
						nil,
						nil,
						upsellEntrySurfaceType.ProfileActionBar,
						false
					))
				end
			}
		}
	end
}
