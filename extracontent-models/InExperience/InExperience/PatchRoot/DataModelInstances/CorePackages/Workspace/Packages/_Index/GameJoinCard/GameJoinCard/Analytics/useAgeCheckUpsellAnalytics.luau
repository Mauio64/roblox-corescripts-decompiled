local parent = script:FindFirstAncestor("GameJoinCard").Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local dependencyArray = RoactUtils.Hooks.dependencyArray

local SharedFlags = require(parent.SharedFlags)
local FFlagGameJoinCardAnalyticsCardId = SharedFlags.FFlagGameJoinCardAnalyticsCardId

local AnalyticsConstants = require(script.Parent.AnalyticsConstants)
local GameJoinCardButtonAction = AnalyticsConstants.GameJoinCardButtonAction
local useGameJoinCardAnalytics = require(script.Parent.useGameJoinCardAnalytics)
local UseAgeCheckUpsellAnalytics = {}

function UseAgeCheckUpsellAnalytics.useAgeCheckCompletionLogger(universeId: string)
	if universeId == "" then
		universeId = nil
	end

	return React.useCallback(function(outcome)
		useGameJoinCardAnalytics.logJoinCardAgeCheckVerificationOutcome({
			universeId = universeId,
			outcome = outcome
		})
	end, { universeId })
end

function UseAgeCheckUpsellAnalytics.useAgeCheckPressLogger(data)
	local userId = data.userId
	local absolutePosition = data.absolutePosition
	local joinGameCardId = data.joinGameCardId
	local joinAgeCheckUpsellFlow = data.joinAgeCheckUpsellFlow
	local universeId

	if data.universeId == "" then
		universeId = nil
	else
		universeId = data.universeId
	end

	local useCallback = React.useCallback
	local function fn()
		local logGameJoinCardButtonEvent = useGameJoinCardAnalytics.logGameJoinCardButtonEvent
		local ageCheckUnlock = GameJoinCardButtonAction.AgeCheckUnlock
		local v = {
			friendId = userId,
			universeId = universeId,
			absolutePosition = absolutePosition,
			joinGameCardId = nil
		}
		local joinGameCardId2

		if FFlagGameJoinCardAnalyticsCardId then
			joinGameCardId2 = joinGameCardId
		end

		v.joinGameCardId = joinGameCardId2
		logGameJoinCardButtonEvent(ageCheckUnlock, v)

		joinAgeCheckUpsellFlow()
	end

	local v

	if FFlagGameJoinCardAnalyticsCardId then
		v = dependencyArray(userId, universeId, absolutePosition, joinGameCardId, joinAgeCheckUpsellFlow)
	else
		v = dependencyArray(userId, universeId, absolutePosition, joinAgeCheckUpsellFlow)
	end

	return useCallback(fn, v)
end

return UseAgeCheckUpsellAnalytics
