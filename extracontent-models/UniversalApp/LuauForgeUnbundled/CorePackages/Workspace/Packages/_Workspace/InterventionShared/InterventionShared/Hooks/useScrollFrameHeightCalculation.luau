local Constants = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/InterventionShared/Utils/Constants")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/React")
local useLayerCollector = require("@game/CorePackages/Workspace/Packages/_Workspace/InterventionShared/UIBlox").Core.Layout.LayerCollector.useLayerCollector

local function useScrollFrameHeightCalculation(data)
	local v5 = useLayerCollector()
	local screenSize = data.screenSize or v5.absoluteSize
	local state, setState = React.useState(data.initialInnerContentHeight or 0)
	local v6 = React.useCallback(function(p2)
		setState(p2.AbsoluteSize.Y)
	end, {})
	local scrollFrameHeaderFooterHeight = data.scrollFrameHeaderFooterHeight or Constants.DIALOG_HEADER_HEIGHT
	local v7 = screenSize.Y - Constants.UNIBAR_HEIGHT - scrollFrameHeaderFooterHeight

	if data.screenSize then
		v7 = math.max(0, v7)
	end

	local v8 = math.ceil((math.min(v7, state)))
	return {
		onInnerContentSizeChanged = v6,
		scrollFrameContainerHeight = v8,
		shouldShowScrollBar = v8 < state
	}
end

return useScrollFrameHeightCalculation
