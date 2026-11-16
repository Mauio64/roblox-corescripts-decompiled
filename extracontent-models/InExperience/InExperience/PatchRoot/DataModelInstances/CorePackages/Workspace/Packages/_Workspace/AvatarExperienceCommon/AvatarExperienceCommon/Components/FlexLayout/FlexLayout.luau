local parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent
local React = require(parent.React)

local Dash = require(parent.Dash)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens

local function FlexLayout(props)
	local v = useDesignTokens()

	local v2 = not (props.flexSlot and props.rigidSlot) and 0 or props.margin or v.Size.Size_400
	local flexDirection = props.flexDirection or Enum.FillDirection.Horizontal
	local reverse = props.reverse or false

	local v3, v4 = React.useBinding(Vector2.new(0, 0))
	local v5 = React.useCallback(function(vector2: Vector2)
		if flexDirection == Enum.FillDirection.Horizontal then
			return UDim2.new(1, -(vector2.X + v2), 1, 0)
		end

		return UDim2.new(1, 0, 1, -(vector2.Y + v2))
	end, { flexDirection, v2 })

	local clone = table.clone(props)

	clone.flexDirection = nil
	clone.reverse = nil
	clone.rigidSlot = nil
	clone.flexSlot = nil
	clone.margin = nil
	clone.padding = nil

	local createElement = React.createElement

	local join = Dash.join
	local size

	if flexDirection == Enum.FillDirection.Horizontal then
		size = UDim2.fromScale(1, 0)
	else
		size = UDim2.fromScale(0, 1)
	end

	local automaticSize

	if flexDirection == Enum.FillDirection.Horizontal then
		automaticSize = Enum.AutomaticSize.Y
	else
		automaticSize = Enum.AutomaticSize.X
	end

	local joined = join(
		{
			Size = size,
			AutomaticSize = automaticSize,
			BackgroundTransparency = 1,
			BorderSizePixel = 0
		},
		clone
	)

	local v6 = {
		UILayout = React.createElement("UIListLayout", {
			FillDirection = flexDirection,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v2)
		}),
		Padding = 0,
		Flex = 0,
		Rigid = 0
	}
	local padding

	if props.padding then
		padding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, props.padding.top or 0),
			PaddingRight = UDim.new(0, props.padding.right or 0),
			PaddingBottom = UDim.new(0, props.padding.bottom or 0),
			PaddingLeft = UDim.new(0, props.padding.left or 0)
		})
	end

	v6.Padding = padding
	local flex

	if props.flexSlot then
		flex = React.createElement("Frame", {
			LayoutOrder = reverse and 1 or 0,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = v3:map(v5)
		}, props.flexSlot)
	end

	v6.Flex = flex
	local rigid

	if props.rigidSlot then
		local createElement2 = React.createElement
		local v7 = {}
		v7.LayoutOrder = reverse and 0 or 1
		v7.BackgroundTransparency = 1
		v7.BorderSizePixel = 0
		local size2

		if flexDirection == Enum.FillDirection.Horizontal then
			size2 = UDim2.new(0, 0, 1, 0)
		else
			size2 = UDim2.new(1, 0, 0, 0)
		end

		v7.Size = size2

		v7.AutomaticSize = Enum.AutomaticSize.XY
		v7[React.Change.AbsoluteSize] = function(p)
			v4(p.AbsoluteSize)
		end

		rigid = createElement2("Frame", v7, props.rigidSlot)
	end

	v6.Rigid = rigid
	return createElement("Frame", joined, v6)
end

return FlexLayout
