local InterventionShared = script:FindFirstAncestor("InterventionShared")
local parent = InterventionShared.Parent

local Constants = require(InterventionShared.Utils.Constants)
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local useLayerCollector = UIBlox.Core.Layout.LayerCollector.useLayerCollector

local function useScrollFrameHeightCalculation(data)
	local v = useLayerCollector()
	local screenSize = data.screenSize or v.absoluteSize
	local state, setState = React.useState(data.initialInnerContentHeight or 0)
	local onInnerContentSizeChanged = React.useCallback(function(p)
		setState(p.AbsoluteSize.Y)
	end, {})
	local scrollFrameHeaderFooterHeight = data.scrollFrameHeaderFooterHeight or Constants.DIALOG_HEADER_HEIGHT
	local v2 = screenSize.Y - Constants.UNIBAR_HEIGHT - scrollFrameHeaderFooterHeight

	if data.screenSize then
		v2 = math.max(0, v2)
	end

	local scrollFrameContainerHeight = math.ceil((math.min(v2, state)))
	return {
		onInnerContentSizeChanged = onInnerContentSizeChanged,
		scrollFrameContainerHeight = scrollFrameContainerHeight,
		shouldShowScrollBar = scrollFrameContainerHeight < state
	}
end

return useScrollFrameHeightCalculation
