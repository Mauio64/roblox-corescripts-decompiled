local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/Foundation")
local userCtaAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/UserCtaCommon").Enums.UserCtaAction

local buttonVariant = Foundation.Enums.ButtonVariant
local inputSize = Foundation.Enums.InputSize

local gameJoinCardButtonAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/AnalyticsConstants").GameJoinCardButtonAction
local useGameJoinCardAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useGameJoinCardAnalytics")
require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/Types")
local getTelemetryFields = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/getTelemetryFields")
local logGamePlayIntent = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Components/Actions/logGamePlayIntent")

return {
	[userCtaAction.JoinExperience] = function(data)
		local experience = data.experience
		local v6 = {
			id = userCtaAction.JoinExperience,
			variant = buttonVariant.Emphasis,
			inputSize = inputSize.Medium,
			width = UDim.new(1, 0),
			isLoading = experience.isLoading,
			isDisabled = 0,
			text = 0,
			onActivated = 0
		}
		local v7 = if experience.isInExperience ~= nil then not experience.isInExperience else nil
		v6.isDisabled = v7
		v6.text = data.localized[userCtaAction.JoinExperience]
		function v6.onActivated()
			if data.userId ~= "" then
				useGameJoinCardAnalytics.logGameJoinCardButtonEvent(gameJoinCardButtonAction.JoinGame, getTelemetryFields(data))
			end

			logGamePlayIntent(data)
			experience.joinExperience()
		end

		return v6
	end
}
