local InterventionShared = script:FindFirstAncestor("InterventionShared")
local InterventionSharedParent = InterventionShared.Parent
local Constants = require(InterventionShared.Utils.Constants)
local React = require(InterventionSharedParent.React)
local useLayerCollector = require(InterventionSharedParent.UIBlox).Core.Layout.LayerCollector.useLayerCollector

local function useScrollFrameHeightCalculation(t1: {[any]: any}) -- line: 46
	-- upvalues: useLayerCollector (copy), React (copy), Constants (copy)
	local absoluteSize = useLayerCollector().absoluteSize
	local v9, v10 = React.useState(t1.initialInnerContentHeight or 0)
	local v11 = React.useCallback(function(p1) -- line: 50
		-- upvalues: v10 (copy)
		v10(p1.AbsoluteSize.Y)
	end, {})
	local v12 = t1.scrollFrameHeaderFooterHeight or Constants.DIALOG_HEADER_HEIGHT
	local v13 = math.ceil((math.min(absoluteSize.Y - Constants.UNIBAR_HEIGHT - v12, v9)))
	local v14 = v13 < v9

	return {
		onInnerContentSizeChanged = v11,
		scrollFrameContainerHeight = v13,
		shouldShowScrollBar = v14
	}
end

return useScrollFrameHeightCalculation
