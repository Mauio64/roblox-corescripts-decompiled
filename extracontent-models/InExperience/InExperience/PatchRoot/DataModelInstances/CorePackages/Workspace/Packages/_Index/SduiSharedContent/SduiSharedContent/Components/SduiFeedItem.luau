local Parent = script:FindFirstAncestor("SduiSharedContent").Parent
local React = require(Parent.React)
local useImpressionsTagger = require(Parent.Impressions).useImpressionsTagger

local function SduiFeedItem(t1: {[any]: any}) -- line: 17
	-- upvalues: React (copy), useImpressionsTagger (copy)
	local v6 = React.useRef(nil)

	useImpressionsTagger(v6, t1.impressionsTag, t1.index)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		SelectionGroup = true,
		ref = v6,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		SelectionBehaviorLeft = t1.selectionBehaviorLeft,
		SelectionBehaviorRight = t1.selectionBehaviorRight,
		LayoutOrder = t1.layoutOrder,
		ZIndex = t1.zIndex
	}, t1.children)
end

return React.memo(SduiFeedItem)
