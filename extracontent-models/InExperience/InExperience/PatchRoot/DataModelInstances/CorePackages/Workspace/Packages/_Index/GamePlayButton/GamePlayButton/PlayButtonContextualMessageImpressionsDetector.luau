local parent = script:FindFirstAncestor("GamePlayButton").Parent
local React = require(parent.React)
local Impressions = require(parent.Impressions)
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local useImpressionsTagger = Impressions.useImpressionsTagger
require(parent.AppCommonLib)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
require(parent.PlayabilityRodux)

local sendPlayButtonContextualMessageImpressionEvent = DiscoveryAnalytics.Events.sendPlayButtonContextualMessageImpressionEvent

local function PlayButtonContextualMessageImpressionsDetector(props)
	local playabilityStatus = props.playabilityStatus and props.playabilityStatus.playabilityStatus
	local formatted = `PLAY_BUTTON_CONTEXTUAL_MESSAGE_{props.universeId}_{playabilityStatus}`

	useImpressionsTagger(props.containerRef, formatted, 1)

	local sendImpressions = React.useCallback(function(list)
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
	end, { props.universeId, props.pageContext, playabilityStatus, props.contextualMessage })

	if props.contextualMessage and props.contextualMessage ~= "" then
		return React.createElement(ScreenSizeImpressionsTracker, {
			pageContext = props.pageContext,
			impressionsTag = formatted,
			scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
			sendImpressions = sendImpressions,
			ignoreBottomInset = true
		})
	end

	return nil
end

return PlayButtonContextualMessageImpressionsDetector
