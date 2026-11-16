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
	[UserCtaAction.JoinExperience] = function(data)
		local experience = data.experience
		local v = {
			id = UserCtaAction.JoinExperience,
			variant = ButtonVariant.Emphasis,
			inputSize = InputSize.Medium,
			width = UDim.new(1, 0),
			isLoading = experience.isLoading,
			isDisabled = 0,
			text = 0,
			onActivated = 0
		}
		local isDisabled

		if experience.isInExperience ~= nil then
			isDisabled = not experience.isInExperience
		end

		v.isDisabled = isDisabled
		v.text = data.localized[UserCtaAction.JoinExperience]
		function v.onActivated()
			if data.userId ~= "" then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
					GameJoinCardButtonAction.JoinGame,
					getTelemetryFields(data)
				)
			end

			logGamePlayIntent(data)
			experience.joinExperience()
		end

		return v
	end
}
