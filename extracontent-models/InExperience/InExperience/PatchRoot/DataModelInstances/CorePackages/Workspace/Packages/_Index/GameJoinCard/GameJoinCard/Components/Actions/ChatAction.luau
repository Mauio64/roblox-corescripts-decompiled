local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local Foundation = require(parent.Foundation)
local SocialCommon = require(parent.SocialCommon)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local UserCtaCommon = require(parent.UserCtaCommon)
local UserCtaAction = UserCtaCommon.Enums.UserCtaAction

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize
local ChatEntryPointNames = SocialCommon.Enums.ChatEntryPointNames
local EnteredChatFromEntryPoint = SocialCommon.Actions.EnteredChatFromEntryPoint
local NotificationType = RobloxAppEnums.NotificationType

local FFlagGameJoinCardChatEntryPoint = require(GameJoinCard.Flags.FFlagGameJoinCardChatEntryPoint)
local AnalyticsConstants = require(GameJoinCard.Analytics.AnalyticsConstants)
local GameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local useGameJoinCardAnalytics = require(GameJoinCard.Analytics.useGameJoinCardAnalytics)
require(script.Parent.Types)
local getTelemetryFields = require(script.Parent.getTelemetryFields)

return {
	[UserCtaAction.Chat] = function(data)
		return {
			id = UserCtaAction.Chat,
			variant = ButtonVariant.Standard,
			inputSize = InputSize.Medium,
			width = UDim.new(1, 0),
			text = data.localized[UserCtaAction.Chat],
			onActivated = function()
				if data.userId == "" then
					return
				end

				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
					GameJoinCardButtonAction.Chat,
					getTelemetryFields(data)
				)

				if FFlagGameJoinCardChatEntryPoint then
					data.dispatch(EnteredChatFromEntryPoint(ChatEntryPointNames.GameJoinCard))
				end

				data.guiService:BroadcastNotification(data.userId, NotificationType.LAUNCH_CONVERSATION)
			end
		}
	end
}
