local parent = script.Parent.Parent.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local LuauPolyfill = require(parent2.LuauPolyfill)
local Object = LuauPolyfill.Object

local useStyle = require(parent.Core.Style.useStyle)

local Constants = require(script.Parent.Constants)

require(script.Parent.Types)

return function(props, p)
	local v = useStyle()
	local createElement = Roact.createElement
	local size

	if props.size then
		size = props.size
	else
		size = UDim2.new(1, 0, 1, 0)
	end

	local v2 = {
		Size = size,
		AutomaticSize = props.automaticSize,
		BackgroundTransparency = 1,
		LayoutOrder = 1
	}
	local roundedBackgroundWithTopAlignedToContent

	if props.showRoundedBackground then
		roundedBackgroundWithTopAlignedToContent = Roact.createElement("Frame", {
			Size = props.roundedBackgroundSize or UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = props.roundedBackgroundTransparency or 1,
			BackgroundColor3 = props.roundedBackgroundColor or v.Theme.BackgroundUIDefault.Color,
			Position = props.roundedBackgroundPosition or UDim2.fromOffset(0, 0),
			ZIndex = 1
		}, {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
		})
	end

	local overlay

	if props.showOverlay then
		overlay = Roact.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = v.Theme.BackgroundUIDefault.Color,
				BackgroundTransparency = Constants.ICON_TAB_PRESSED_TRANSPARENCY,
				ZIndex = 3
			},
			{
				Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0.5, 0) })
			}
		)
	end

	local createElement2 = Roact.createElement
	local size2

	if props.size then
		size2 = props.size
	else
		size2 = UDim2.new(1, 0, 1, 0)
	end

	local v3 = {
		Size = size2,
		AutomaticSize = props.automaticSize,
		BackgroundTransparency = 1,
		LayoutOrder = 2,
		ZIndex = 2
	}

	local assign = Object.assign
	local v4 = {
		Layout = Roact.createElement("UIListLayout", Object.assign({}, {
			FillDirection = Enum.FillDirection.Horizontal,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, props.spacing or 0)
		})),
		Padding = 0
	}
	local padding

	if props.padding then
		padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, props.padding.left or 0),
			PaddingRight = UDim.new(0, props.padding.right or 0),
			PaddingTop = UDim.new(0, props.padding.top or 0),
			PaddingBottom = UDim.new(0, props.padding.bottom or 0)
		})
	end

	v4.Padding = padding
	return createElement("Frame", v2, {
		RoundedBackgroundWithTopAlignedToContent = roundedBackgroundWithTopAlignedToContent,
		Overlay = overlay,
		Content = createElement2("Frame", v3, assign({}, v4, p))
	})
end
