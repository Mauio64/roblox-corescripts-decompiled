local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local GuiService = game:GetService("GuiService")

local Foundation = require(parent.Foundation)
local SocialCommon = require(parent.SocialCommon)

local ButtonVariant = Foundation.Enums.ButtonVariant
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local EnteredChatFromEntryPoint = require(parent.AppChat.EnteredChatFromEntryPoint)
local notificationTypeList = GuiService:GetNotificationTypeList()

local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.Chat] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.Chat],
			variant = ButtonVariant.Standard,
			onActivated = {
				[ProfileTypes.User] = function()
					if data.buttonSurface == Enums.ButtonSurface.ContextualMenu then
						data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonChat, {
							buttonSurface = data.buttonSurface
						})
					else
						data.analytics.fireAnalyticsEvent(EventNames.CTAButtonChat, {
							buttonSurface = data.buttonSurface
						})
					end

					data.dispatch(EnteredChatFromEntryPoint(ChatEntryPointNames.ProfilePeekView))
					GuiService:BroadcastNotification(data.profileId, notificationTypeList.LAUNCH_CONVERSATION)
				end
			}
		}
	end
}
