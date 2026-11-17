local parent = script.Parent
local parent2 = parent.Parent.Parent
local React = require(parent2.React)
local AdLabel = require(parent2.AdLabel)
local adLabel = AdLabel.AdLabel

local EnhancedVideoStore = require(parent.Parent.EnhancedVideoStore)
local SignalsReact = require(parent2.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local function AdLabelContainer(p)
	local enhancedVideoStore = EnhancedVideoStore(false)
	local adDisclosureText = useSignalState(enhancedVideoStore.getAdDisclosureText)
	local showAdPreferencesUrl = useSignalState(enhancedVideoStore.getShowAdPreferencesUrl)
	return React.createElement(adLabel, {
		sendPauseEvent = p.sendPauseEvent,
		adDisclosureText = adDisclosureText,
		showAdPreferencesUrl = showAdPreferencesUrl
	})
end

return React.memo(AdLabelContainer)
