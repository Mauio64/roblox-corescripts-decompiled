local buttonVariant = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").Enums.ButtonVariant

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ExternalContentSharingProtocol").ExternalContentSharingProtocol.default
local setCurrentToastMessage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ToastRodux").Actions.SetCurrentToastMessage
local contexts = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialLuaAnalytics").Analytics.Enums.Contexts

local profileSharePolicyEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfileShareLinks").Enums.ProfileSharePolicyEnum

local TextKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/TextKeys")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.ShareProfile] = function(data)
		return {
			variant = buttonVariant.Standard,
			text = data.localized[Enums.ProfileActions.ShareProfile],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonShareProfile, {
						buttonSurface = data.buttonSurface
					})

					if data.profileShareLink.policy ~= profileSharePolicyEnum.Disabled then
						data.profileShareLink.onActivated()

						return
					end

					default:setClipboardText({
						context = contexts.ProfileCard,
						text = string.format("%s/%s", data.PROFILE_SHARE_LINK_URL, data.profileId)
					})

					data.dispatch(setCurrentToastMessage({
						toastMessage = TextKeys.LinkCopied
					}))
				end
			}
		}
	end
}
