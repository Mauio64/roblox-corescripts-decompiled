local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/React")
local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/Impressions")
local screenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local useImpressionsTagger = Impressions.useImpressionsTagger
require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/AppCommonLib")
local DiscoveryAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/DiscoveryAnalytics")
require("@game/CorePackages/Workspace/Packages/_Workspace/GamePlayButton/PlayabilityRodux")

local sendPlayButtonContextualMessageImpressionEvent = DiscoveryAnalytics.Events.sendPlayButtonContextualMessageImpressionEvent

local function PlayButtonContextualMessageImpressionsDetector(props)
	local playabilityStatus = props.playabilityStatus and props.playabilityStatus.playabilityStatus
	local formatted = `PLAY_BUTTON_CONTEXTUAL_MESSAGE_{props.universeId}_{playabilityStatus}`

	useImpressionsTagger(props.containerRef, formatted, 1)

	local v5 = React.useCallback(function(list)
		if #list == 0 then
			return
		end

		sendPlayButtonContextualMessageImpressionEvent(
			{
				universeId = props.universeId,
				playabilityStatus = playabilityStatus,
				contextualMessage = props.contextualMessage
			},
			props.pageContext
		)
	end, {
		props.universeId,
		props.pageContext,
		playabilityStatus,
		props.contextualMessage
	})

	if props.contextualMessage and props.contextualMessage ~= "" then
		return React.createElement(screenSizeImpressionsTracker, {
			pageContext = props.pageContext,
			impressionsTag = formatted,
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			sendImpressions = v5,
			ignoreBottomInset = true
		})
	end

	return nil
end

return PlayButtonContextualMessageImpressionsDetector
