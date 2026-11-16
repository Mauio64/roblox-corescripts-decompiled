local GuiService = game:GetService("GuiService")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialCommon")

local buttonVariant = Foundation.Enums.ButtonVariant
local chatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local EnteredChatFromEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AppChat/EnteredChatFromEntryPoint")
local notificationTypeList = GuiService:GetNotificationTypeList()

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.Chat] = function(data)
		return {
			text = data.localized[Enums.ProfileActions.Chat],
			variant = buttonVariant.Standard,
			onActivated = {
				[profileTypes.User] = function()
					if data.buttonSurface == Enums.ButtonSurface.ContextualMenu then
						data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonChat, {
							buttonSurface = data.buttonSurface
						})
					else
						data.analytics.fireAnalyticsEvent(EventNames.CTAButtonChat, {
							buttonSurface = data.buttonSurface
						})
					end

					data.dispatch(EnteredChatFromEntryPoint(chatEntryPointNames.ProfilePeekView))
					GuiService:BroadcastNotification(
						data.profileId,
						notificationTypeList.LAUNCH_CONVERSATION
					)
				end
			}
		}
	end
}
