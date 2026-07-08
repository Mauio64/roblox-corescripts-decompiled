local Parent = script:FindFirstAncestor("GamePlayButton").Parent
local React = require(Parent.React)
local Impressions = require(Parent.Impressions)
local ScreenSizeImpressionsTracker = Impressions.ScreenSizeImpressionsTracker
local useImpressionsTagger = Impressions.useImpressionsTagger

require(Parent.AppCommonLib)

local DiscoveryAnalytics = require(Parent.DiscoveryAnalytics)

require(Parent.PlayabilityRodux)

local sendPlayButtonContextualMessageImpressionEvent = DiscoveryAnalytics.Events.sendPlayButtonContextualMessageImpressionEvent

local function PlayButtonContextualMessageImpressionsDetector(t1: {[any]: any}) -- line: 23
	-- upvalues: useImpressionsTagger (copy), React (copy), sendPlayButtonContextualMessageImpressionEvent (copy), ScreenSizeImpressionsTracker (copy)
	local v10 = t1.playabilityStatus and t1.playabilityStatus.playabilityStatus
	local v11 = `PLAY_BUTTON_CONTEXTUAL_MESSAGE_{ t1.universeId }_{ v10 }`

	useImpressionsTagger(t1.containerRef, v11, 1)

	local v12 = React.useCallback(function(t2: {[any]: any}) -- line: 30
		-- upvalues: sendPlayButtonContextualMessageImpressionEvent (copy), t1 (copy), v10 (copy)
		if #t2 == 0 then
			return
		end

		sendPlayButtonContextualMessageImpressionEvent({
			universeId = t1.universeId,
			playabilityStatus = v10,
			contextualMessage = t1.contextualMessage
		}, t1.pageContext)
	end, {
		t1.universeId,
		t1.pageContext,
		v10,
		t1.contextualMessage
	})

	if not t1.contextualMessage or t1.contextualMessage == "" then
		return nil
	end

	return React.createElement(ScreenSizeImpressionsTracker, {
		ignoreBottomInset = true,
		pageContext = t1.pageContext,
		impressionsTag = v11,
		scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal,
		sendImpressions = v12
	})
end

return PlayButtonContextualMessageImpressionsDetector
