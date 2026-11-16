local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/React")
local dependencyArray = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/RoactUtils").Hooks.dependencyArray

local fFlagGameJoinCardAnalyticsCardId = require("@game/CorePackages/Workspace/Packages/_Workspace/GameJoinCard/SharedFlags").FFlagGameJoinCardAnalyticsCardId

local gameJoinCardButtonAction = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/AnalyticsConstants").GameJoinCardButtonAction
local useGameJoinCardAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/GameJoinCard/GameJoinCard/Analytics/useGameJoinCardAnalytics")

return {
	useAgeCheckCompletionLogger = function(p2)
		if p2 == "" then
			p2 = nil
		end

		return React.useCallback(function(p3)
			useGameJoinCardAnalytics.logJoinCardAgeCheckVerificationOutcome({
				universeId = p2,
				outcome = p3
			})
		end, { p2 })
	end,
	useAgeCheckPressLogger = function(data)
		local userId = data.userId
		local absolutePosition = data.absolutePosition
		local joinGameCardId = data.joinGameCardId
		local joinAgeCheckUpsellFlow = data.joinAgeCheckUpsellFlow
		local universeId = if data.universeId ~= "" then data.universeId else nil

		local useCallback = React.useCallback
		local function fn()
			useGameJoinCardAnalytics.logGameJoinCardButtonEvent(gameJoinCardButtonAction.AgeCheckUnlock, {
				friendId = userId,
				universeId = universeId,
				absolutePosition = absolutePosition,
				joinGameCardId = if fFlagGameJoinCardAnalyticsCardId then joinGameCardId else nil
			})

			joinAgeCheckUpsellFlow()
		end

		local v5 = if fFlagGameJoinCardAnalyticsCardId then dependencyArray(
			userId,
			universeId,
			absolutePosition,
			joinGameCardId,
			joinAgeCheckUpsellFlow
		) else dependencyArray(userId, universeId, absolutePosition, joinAgeCheckUpsellFlow)
		return useCallback(fn, v5)
	end
}
