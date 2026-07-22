local Parent = script:FindFirstAncestor("Impressions").Parent
local React = require(Parent.React)
local ImpressionsTracker = require(script.Parent.ImpressionsTracker)
local useViewportBounds = require(Parent.ViewportUtils).useViewportBounds
local SharedFlags = require(Parent.SharedFlags)
local FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions
local FFlagLuaAppRespectClipAncestorImpressions = SharedFlags.FFlagLuaAppRespectClipAncestorImpressions

return function(t1: {[any]: any}) -- line: 27
	-- upvalues: FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions (copy), useViewportBounds (copy), FFlagLuaAppRespectClipAncestorImpressions (copy), React (copy), ImpressionsTracker (copy)
	local v9 = nil
	local v10

	if FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then
		v10, v9 = useViewportBounds(t1.parentRef, nil, if not FFlagLuaAppRespectClipAncestorImpressions then nil else t1.respectClipAncestors)
	else
		v10 = useViewportBounds(t1.parentRef, nil, if not FFlagLuaAppRespectClipAncestorImpressions then nil else t1.respectClipAncestors)
	end

	return React.createElement(ImpressionsTracker, {
		pageContext = t1.pageContext,
		parentRef = t1.parentRef,
		impressionsTag = t1.impressionsTag,
		scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal,
		sendImpressions = t1.sendImpressions,
		dataUpdatedTimestamp = t1.dataUpdatedTimestamp,
		viewPortBounds = v10,
		viewPortFillBounds = if not FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then nil else v9
	})
end
