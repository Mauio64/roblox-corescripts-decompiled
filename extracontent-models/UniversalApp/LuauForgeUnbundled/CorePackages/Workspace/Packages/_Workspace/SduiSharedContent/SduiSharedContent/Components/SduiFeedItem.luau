local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/React")
local useImpressionsTagger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/Impressions").useImpressionsTagger
local fFlagAppPageShellScrollToTopFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiSharedContent/SharedFlags").FFlagAppPageShellScrollToTopFocus

local function SduiFeedItem(props)
	local ref = React.useRef(nil)
	local v5

	if fFlagAppPageShellScrollToTopFocus then
		v5 = React.useCallback(function(current)
			ref.current = current

			if type(props.defaultFocusRef) == "function" then
				props.defaultFocusRef(current)
			elseif type(props.defaultFocusRef) == "table" then
				props.defaultFocusRef.current = current
			end
		end, { props.defaultFocusRef })
	end

	useImpressionsTagger(ref, props.impressionsTag, props.index)

	local createElement = React.createElement

	if not fFlagAppPageShellScrollToTopFocus then
		v5 = ref
	end

	return createElement("Frame", {
		ref = v5,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		SelectionGroup = true,
		SelectionBehaviorLeft = props.selectionBehaviorLeft,
		SelectionBehaviorRight = props.selectionBehaviorRight,
		LayoutOrder = props.layoutOrder,
		ZIndex = props.zIndex
	}, props.children)
end

return React.memo(SduiFeedItem)
