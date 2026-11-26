local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SocialCommon")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RobloxAppEnums")
local userCtaAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserCtaCommon").Enums.UserCtaAction

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize
local chatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local enteredChatFromEntryPoint = SocialCommon.Actions.EnteredChatFromEntryPoint
local notificationType = RobloxAppEnums.NotificationType

local FFlagGameJoinCardChatEntryPoint = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Flags/FFlagGameJoinCardChatEntryPoint")
local gameJoinCardButtonAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/AnalyticsConstants").GameJoinCardButtonAction
local useGameJoinCardAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useGameJoinCardAnalytics")
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")
local getTelemetryFields = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/getTelemetryFields")

return {
	[userCtaAction.Chat] = function(data)
		return {
			id = userCtaAction.Chat,
			variant = buttonVariant.Standard,
			inputSize = inputSize.Medium,
			width = UDim.new(1, 0),
			text = data.localized[userCtaAction.Chat],
			onActivated = function()
				if data.userId == "" then
					return
				end

				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(gameJoinCardButtonAction.Chat, getTelemetryFields(data))

				if FFlagGameJoinCardChatEntryPoint then
					data.dispatch(enteredChatFromEntryPoint(chatEntryPointNames.GameJoinCard))
				end

				data.guiService:BroadcastNotification(data.userId, notificationType.LAUNCH_CONVERSATION)
			end
		}
	end
}
