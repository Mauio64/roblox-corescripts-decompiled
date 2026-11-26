local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")
local module2 = require("@luauforge/bundled/fxu")

local module3 = require("@luauforge/bundled/fxE")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/BulkPurchaseApp/Components/Divider")

local axRecentlyViewedSearchItemsIXPTest = module2.Experiments.AXRecentlyViewedSearchItemsIXPTest

local function SuggestedItemList(props)
	local v5 = React.useMemo(function()
		local children = {}

		children.Layout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical
		})

		for k, item in props.items do
			local formatted = `SuggestedItem{k}`
			local createElement = React.createElement
			local v7 = {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				AnchorPoint = Vector2.new(0, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				LayoutOrder = k
			}

			local children2 = {
				ItemLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				Item = 0,
				Divider = 0
			}

			local createElement2 = React.createElement
			local v9 = {
				text = item.text,
				type = item.type,
				onActivate = item.onActivate,
				onTrailingButtonActivate = item.onRemove,
				layoutOrder = 0,
				ref = 0
			}

			local v10 = if k == 1 then props.firstSuggestedItemRef else nil
			v9.ref = v10
			children2.Item = createElement2(module3, v9)

			local v11 = if k < #props.items then React.createElement(module4, {
				layoutOrder = 1
			}) else nil
			children2.Divider = v11
			children[formatted] = createElement("Frame", v7, children2)
		end

		return children
	end, { props.items })

	local createElement = React.createElement
	local v7 = {
		BorderSizePixel = 0,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		AutomaticSize = 0,
		BackgroundTransparency = 1,
		CanvasSize = 0,
		ScrollBarThickness = 0,
		ScrollingDirection = 0,
		Selectable = false,
		Size = 0
	}
	local v8 = if axRecentlyViewedSearchItemsIXPTest.isEnabled() and props.disableScroll then Enum.AutomaticSize.Y else nil
	v7.AutomaticSize = v8

	v7.CanvasSize = UDim2.fromScale(1, 1)

	v7.ScrollingDirection = Enum.ScrollingDirection.Y

	v7.Size = UDim2.fromScale(1, 1)
	return createElement("ScrollingFrame", v7, v5)
end

return SuggestedItemList
