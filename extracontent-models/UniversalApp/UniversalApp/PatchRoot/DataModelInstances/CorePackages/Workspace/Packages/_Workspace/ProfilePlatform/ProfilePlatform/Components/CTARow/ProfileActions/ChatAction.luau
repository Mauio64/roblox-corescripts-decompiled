local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local GuiService = game:GetService("GuiService")
local Foundation = require(ProfilePlatformParent.Foundation)
local SocialCommon = require(ProfilePlatformParent.SocialCommon)
local ButtonVariant = Foundation.Enums.ButtonVariant
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local EnteredChatFromEntryPoint = require(ProfilePlatformParent.AppChat.EnteredChatFromEntryPoint)
local NotificationTypeList = GuiService:GetNotificationTypeList()
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.Chat] = function(p1) -- line: 19
		-- upvalues: Enums (copy), ButtonVariant (copy), ProfileTypes (copy), EventNames (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), NotificationTypeList (copy)
		return {
			text = p1.localized[Enums.ProfileActions.Chat],
			variant = ButtonVariant.Standard,
			onActivated = {
				[ProfileTypes.User] = function() -- line: 24
					-- upvalues: p1 (copy), Enums (copy), EventNames (copy), EnteredChatFromEntryPoint (copy), ChatEntryPointNames (copy), GuiService (copy), NotificationTypeList (copy)
					if p1.buttonSurface == Enums.ButtonSurface.ContextualMenu then
						p1.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonChat, {
							buttonSurface = p1.buttonSurface
						})
					else
						p1.analytics.fireAnalyticsEvent(EventNames.CTAButtonChat, {
							buttonSurface = p1.buttonSurface
						})
					end

					p1.dispatch(EnteredChatFromEntryPoint(ChatEntryPointNames.ProfilePeekView))
					GuiService:BroadcastNotification(p1.profileId, NotificationTypeList.LAUNCH_CONVERSATION)
				end
			}
		}
	end
}
