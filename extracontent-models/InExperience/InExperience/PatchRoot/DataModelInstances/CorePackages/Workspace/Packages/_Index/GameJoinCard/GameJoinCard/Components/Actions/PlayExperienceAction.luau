local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local Foundation = require(parent.Foundation)
local UserCtaCommon = require(parent.UserCtaCommon)
local UserCtaAction = UserCtaCommon.Enums.UserCtaAction

local ButtonVariant = Foundation.Enums.ButtonVariant
local InputSize = Foundation.Enums.InputSize

local AnalyticsConstants = require(GameJoinCard.Analytics.AnalyticsConstants)
local GameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local useGameJoinCardAnalytics = require(GameJoinCard.Analytics.useGameJoinCardAnalytics)
require(script.Parent.Types)
local getTelemetryFields = require(script.Parent.getTelemetryFields)
local logGamePlayIntent = require(script.Parent.logGamePlayIntent)

return {
	[UserCtaAction.PlayExperience] = function(data)
		local experience = data.experience
		return {
			id = UserCtaAction.PlayExperience,
			variant = ButtonVariant.Emphasis,
			inputSize = InputSize.Medium,
			width = UDim.new(1, 0),
			isLoading = experience.isLoading,
			text = data.localized[UserCtaAction.PlayExperience],
			onActivated = function()
				if data.userId ~= "" then
					useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
						GameJoinCardButtonAction.PlayExperience,
						getTelemetryFields(data)
					)
				end

				logGamePlayIntent(data)
				experience.playExperience()
			end
		}
	end
}
