local parent = script:FindFirstAncestor("Moments").Parent

local Foundation = require(parent.Foundation)
local React = require(parent.React)

local usePostInsightsCoachmarkViewModel = require(script.Parent.usePostInsightsCoachmarkViewModel)

local function PostInsightsCoachmark(p)
	local v = usePostInsightsCoachmarkViewModel(p)

	if not v.shouldMount then
		return p.children
	end

	local PersistentCoachmark = require(parent.MomentsCommon.PersistentCoachmark)

	return React.createElement(PersistentCoachmark, {
		title = v.title,
		text = v.text,
		impressionCache = v.impressionCache,
		maxImpressions = v.maxImpressions,
		autoDismissSeconds = v.autoDismissSeconds,
		isSessionHandled = v.isSessionHandled,
		onSessionHandled = v.onSessionHandled,
		onImpression = v.onImpression,
		onDismissed = v.onDismissed,
		hidden = v.hidden,
		side = Foundation.Enums.PopoverSide.Left,
		align = Foundation.Enums.PopoverAlign.Center
	}, p.children)
end

return PostInsightsCoachmark
