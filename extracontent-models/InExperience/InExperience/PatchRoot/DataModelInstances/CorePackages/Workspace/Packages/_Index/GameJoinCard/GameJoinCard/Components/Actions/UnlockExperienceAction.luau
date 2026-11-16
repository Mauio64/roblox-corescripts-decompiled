local GameJoinCard = script:FindFirstAncestor("GameJoinCard")
local parent = GameJoinCard.Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)
local UserCtaCommon = require(parent.UserCtaCommon)
local UserCtaAction = UserCtaCommon.Enums.UserCtaAction

local InputSize = Foundation.Enums.InputSize

local AgeCheckUpsellCTA = require(GameJoinCard.Components.AgeCheckUpsellCTA)
local AnalyticsConstants = require(GameJoinCard.Analytics.AnalyticsConstants)
local GameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local useGameJoinCardAnalytics = require(GameJoinCard.Analytics.useGameJoinCardAnalytics)
require(script.Parent.Types)
local getTelemetryFields = require(script.Parent.getTelemetryFields)

return {
	[UserCtaAction.UnlockExperience] = function(p)
		return {
			id = UserCtaAction.UnlockExperience,
			inputSize = InputSize.Medium,
			width = UDim.new(1, 0),
			text = p.localized[UserCtaAction.UnlockExperience],
			keepOpenOnActivate = true,
			render = function(p2, layoutOrder)
				return React.createElement(AgeCheckUpsellCTA, {
					onUnlockPressed = p2.onActivated,
					LayoutOrder = layoutOrder,
					focusRef = p2.focusRef
				})
			end,
			onActivated = function()
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
					GameJoinCardButtonAction.AgeCheckUnlock,
					getTelemetryFields(p)
				)

				p.joinAgeCheckUpsellFlow()
			end
		}
	end
}
