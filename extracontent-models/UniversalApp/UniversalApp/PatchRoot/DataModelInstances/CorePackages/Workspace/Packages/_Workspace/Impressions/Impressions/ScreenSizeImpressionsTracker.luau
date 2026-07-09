local Parent = script:FindFirstAncestor("Impressions").Parent
local React = require(Parent.React)
local ImpressionsTracker = require(script.Parent.ImpressionsTracker)
local useViewportBounds = require(Parent.ViewportUtils).useViewportBounds

return function(t1: {[any]: any}) -- line: 30
	-- upvalues: useViewportBounds (copy), React (copy), ImpressionsTracker (copy)
	local v6 = useViewportBounds(nil, t1.ignoreBottomInset)

	return React.createElement(ImpressionsTracker, {
		pageContext = t1.pageContext,
		parentRef = t1.parentRef,
		impressionsTag = t1.impressionsTag,
		scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal,
		sendImpressions = t1.sendImpressions,
		dataUpdatedTimestamp = t1.dataUpdatedTimestamp,
		viewPortBounds = v6
	})
end
