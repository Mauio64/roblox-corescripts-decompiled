local Parent = script:FindFirstAncestor("Impressions").Parent
local React = require(Parent.React)
local ImpressionsTracker = require(script.Parent.ImpressionsTracker)
local useViewportBounds = require(Parent.ViewportUtils).useViewportBounds
local FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = require(Parent.SharedFlags).FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions

return function(t1: {[any]: any}) -- line: 25
	-- upvalues: FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions (copy), useViewportBounds (copy), React (copy), ImpressionsTracker (copy)
	local v7 = nil
	local v8

	if FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then
		v8, v7 = useViewportBounds(t1.parentRef)
	else
		v8 = useViewportBounds(t1.parentRef)
	end

	return React.createElement(ImpressionsTracker, {
		pageContext = t1.pageContext,
		parentRef = t1.parentRef,
		impressionsTag = t1.impressionsTag,
		scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal,
		sendImpressions = t1.sendImpressions,
		dataUpdatedTimestamp = t1.dataUpdatedTimestamp,
		viewPortBounds = v8,
		viewPortFillBounds = if not FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then nil else v7
	})
end
