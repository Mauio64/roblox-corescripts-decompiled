local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Foundation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/React")

local usePostInsightsCoachmarkViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/PostInsights/usePostInsightsCoachmarkViewModel")

local function PostInsightsCoachmark(p2)
	local v5 = usePostInsightsCoachmarkViewModel(p2)

	if not v5.shouldMount then
		return p2.children
	end

	local PersistentCoachmark = require("@game/CorePackages/Workspace/Packages/_Index/Moments/MomentsCommon/PersistentCoachmark")

	return React.createElement(PersistentCoachmark, {
		title = v5.title,
		text = v5.text,
		impressionCache = v5.impressionCache,
		maxImpressions = v5.maxImpressions,
		autoDismissSeconds = v5.autoDismissSeconds,
		isSessionHandled = v5.isSessionHandled,
		onSessionHandled = v5.onSessionHandled,
		onImpression = v5.onImpression,
		onDismissed = v5.onDismissed,
		hidden = v5.hidden,
		side = Foundation.Enums.PopoverSide.Left,
		align = Foundation.Enums.PopoverAlign.Center
	}, p2.children)
end

return PostInsightsCoachmark
