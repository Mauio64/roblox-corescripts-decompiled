local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local userCtaAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserCtaCommon").Enums.UserCtaAction

local inputSize = Foundation.Enums.InputSize

local AgeCheckUpsellCTA = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/AgeCheckUpsellCTA")
local gameJoinCardButtonAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/AnalyticsConstants").GameJoinCardButtonAction
local useGameJoinCardAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useGameJoinCardAnalytics")
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")
local getTelemetryFields = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/getTelemetryFields")

return {
	[userCtaAction.UnlockExperience] = function(p2)
		return {
			id = userCtaAction.UnlockExperience,
			inputSize = inputSize.Medium,
			width = UDim.new(1, 0),
			text = p2.localized[userCtaAction.UnlockExperience],
			keepOpenOnActivate = true,
			render = function(p3, p4)
				return React.createElement(AgeCheckUpsellCTA, {
					onUnlockPressed = p3.onActivated,
					LayoutOrder = p4,
					focusRef = p3.focusRef
				})
			end,
			onActivated = function()
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(gameJoinCardButtonAction.AgeCheckUnlock, getTelemetryFields(p2))

				p2.joinAgeCheckUpsellFlow()
			end
		}
	end
}
