local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local React = require(parent.React)
local Impressions = require(parent.Impressions)
local useImpressionsTagger = Impressions.useImpressionsTagger
local SharedFlags = require(parent.SharedFlags)
local FFlagAppPageShellScrollToTopFocus = SharedFlags.FFlagAppPageShellScrollToTopFocus

local function SduiFeedItem(props)
	local ref = React.useRef(nil)
	local ref2

	if FFlagAppPageShellScrollToTopFocus then
		ref2 = React.useCallback(function(current)
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

	if not FFlagAppPageShellScrollToTopFocus then
		ref2 = ref
	end

	return createElement("Frame", {
		ref = ref2,
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
