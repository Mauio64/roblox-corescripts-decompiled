local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)

local ButtonVariant = Foundation.Enums.ButtonVariant

local ExternalContentSharingProtocol = require(parent.ExternalContentSharingProtocol)
local default = ExternalContentSharingProtocol.ExternalContentSharingProtocol.default
local ToastRodux = require(parent.ToastRodux)
local SetCurrentToastMessage = ToastRodux.Actions.SetCurrentToastMessage
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local Contexts = SocialLuaAnalytics.Analytics.Enums.Contexts

local ProfileShareLinks = require(parent.ProfileShareLinks)
local ProfileSharePolicyEnum = ProfileShareLinks.Enums.ProfileSharePolicyEnum

local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.ShareProfile] = function(data)
		return {
			variant = ButtonVariant.Standard,
			text = data.localized[Enums.ProfileActions.ShareProfile],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonShareProfile, {
						buttonSurface = data.buttonSurface
					})

					if data.profileShareLink.policy ~= ProfileSharePolicyEnum.Disabled then
						data.profileShareLink.onActivated()

						return
					end

					default:setClipboardText({
						context = Contexts.ProfileCard,
						text = string.format("%s/%s", data.PROFILE_SHARE_LINK_URL, data.profileId)
					})

					data.dispatch(SetCurrentToastMessage({ toastMessage = TextKeys.LinkCopied }))
				end
			}
		}
	end
}
