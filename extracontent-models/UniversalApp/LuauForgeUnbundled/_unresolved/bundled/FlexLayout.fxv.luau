local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")

local module2 = require("@luauforge/bundled/fxw")
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/Style").useDesignTokens

local function FlexLayout(props)
	local v5 = useDesignTokens()

	local v6 = not (props.flexSlot and props.rigidSlot) and 0 or props.margin or v5.Size.Size_400
	local flexDirection = props.flexDirection or Enum.FillDirection.Horizontal
	local reverse = props.reverse or false

	local v7, v8 = React.useBinding(Vector2.new(0, 0))
	local v9 = React.useCallback(function(p2)
		if flexDirection == Enum.FillDirection.Horizontal then
			return UDim2.new(1, -(p2.X + v6), 1, 0)
		end

		return UDim2.new(1, 0, 1, -(p2.Y + v6))
	end, { flexDirection, v6 })

	local clone = table.clone(props)

	clone.flexDirection = nil
	clone.reverse = nil
	clone.rigidSlot = nil
	clone.flexSlot = nil
	clone.margin = nil
	clone.padding = nil

	local createElement = React.createElement

	local join = module2.join
	local v12 = if flexDirection == Enum.FillDirection.Horizontal then UDim2.fromScale(1, 0) else UDim2.fromScale(0, 1)
	local v13 = if flexDirection == Enum.FillDirection.Horizontal then Enum.AutomaticSize.Y else Enum.AutomaticSize.X
	local joined = join(
		{
			Size = v12,
			AutomaticSize = v13,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		clone
	)

	local v14 = {
		UILayout = React.createElement("UIListLayout", {
			FillDirection = flexDirection,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v6)
		}),
		Padding = 0,
		Flex = 0,
		Rigid = 0
	}

	local v15 = if props.padding then React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, props.padding.top or 0),
		PaddingRight = UDim.new(0, props.padding.right or 0),
		PaddingBottom = UDim.new(0, props.padding.bottom or 0),
		PaddingLeft = UDim.new(0, props.padding.left or 0)
	}) else nil
	v14.Padding = v15

	local v16 = if props.flexSlot then React.createElement("Frame", {
		LayoutOrder = reverse and 1 or 0,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = v7:map(v9)
	}, props.flexSlot) else nil
	v14.Flex = v16
	local v17

	if props.rigidSlot then
		local createElement2 = React.createElement

		local v20 = if flexDirection == Enum.FillDirection.Horizontal then UDim2.new(0, 0, 1, 0) else UDim2.new(1, 0, 0, 0)
		v17 = createElement2("Frame", {
			LayoutOrder = reverse and 0 or 1,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = v20,
			AutomaticSize = Enum.AutomaticSize.XY,
			[React.Change.AbsoluteSize] = function(p2)
				v8(p2.AbsoluteSize)
			end
		}, props.rigidSlot)
	end

	v14.Rigid = v17
	return createElement("Frame", joined, v14)
end

return FlexLayout
