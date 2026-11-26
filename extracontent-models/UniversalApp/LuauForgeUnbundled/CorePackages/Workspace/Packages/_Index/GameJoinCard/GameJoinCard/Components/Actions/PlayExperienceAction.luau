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
	[userCtaAction.PlayExperience] = function(data)
		local experience = data.experience
		return {
			id = userCtaAction.PlayExperience,
			variant = buttonVariant.Emphasis,
			inputSize = inputSize.Medium,
			width = UDim.new(1, 0),
			isLoading = experience.isLoading,
			text = data.localized[userCtaAction.PlayExperience],
			onActivated = function()
				if data.userId ~= "" then
					useGameJoinCardAnalytics.logGameJoinCardButtonEvent(
						gameJoinCardButtonAction.PlayExperience,
						getTelemetryFields(data)
					)
				end

				logGamePlayIntent(data)
				experience.playExperience()
			end
		}
	end
}
