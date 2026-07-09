local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local ButtonVariant = require(ProfilePlatformParent.Foundation).Enums.ButtonVariant
local default = require(ProfilePlatformParent.ExternalContentSharingProtocol).ExternalContentSharingProtocol.default
local SetCurrentToastMessage = require(ProfilePlatformParent.ToastRodux).Actions.SetCurrentToastMessage
local Contexts = require(ProfilePlatformParent.SocialLuaAnalytics).Analytics.Enums.Contexts
local ProfileSharePolicyEnum = require(ProfilePlatformParent.ProfileShareLinks).Enums.ProfileSharePolicyEnum
local TextKeys = require(ProfilePlatform.Common.TextKeys)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.ShareProfile] = function(p1) -- line: 24
		-- upvalues: ButtonVariant (copy), Enums (copy), ProfileTypes (copy), EventNames (copy), ProfileSharePolicyEnum (copy), default (copy), Contexts (copy), SetCurrentToastMessage (copy), TextKeys (copy)
		return {
			variant = ButtonVariant.Standard,
			text = p1.localized[Enums.ProfileActions.ShareProfile],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 29
					-- upvalues: p1 (copy), EventNames (copy), ProfileSharePolicyEnum (copy), default (copy), Contexts (copy), SetCurrentToastMessage (copy), TextKeys (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.CTAButtonShareProfile, {
						buttonSurface = p1.buttonSurface
					})

					if p1.profileShareLink.policy == ProfileSharePolicyEnum.Disabled then
						default:setClipboardText({
							context = Contexts.ProfileCard,
							text = string.format("%s/%s", p1.PROFILE_SHARE_LINK_URL, p1.profileId)
						})
						p1.dispatch(SetCurrentToastMessage({
							toastMessage = TextKeys.LinkCopied
						}))

						return
					end

					p1.profileShareLink.onActivated()
				end
			}
		}
	end
}
