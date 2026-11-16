local parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(parent.React)
local Style = require(parent.Style)
local useDesignTokens = Style.useDesignTokens
local InfoCarouselCell = require(script.Parent.InfoCarouselCell)

return function(props)
	local v = useDesignTokens()
	local padding = props.padding or v.Size.Size_600

	local v2, v3 = React.useBinding(0)

	local children = {}

	local function fn(p)
		v3(p.AbsoluteSize.Y)
	end

	for k, v4 in props.data do
		children["Cell" .. k] = React.createElement(InfoCarouselCell, {
			LayoutOrder = k * 2,
			headerText = v4.headerText,
			bodyText = v4.bodyText,
			icon = v4.icon,
			iconSize = props.iconSize,
			onActivated = v4.onActivated,
			padding = props.cellPadding
		})

		if k < #props.data then
			children["Divider" .. k] = React.createElement("Frame", {
				LayoutOrder = k * 2 + 1,
				Size = v2:map(function(p: number)
					return UDim2.fromOffset(1, p / 2)
				end),
				BorderColor3 = v.Color.Stroke.Emphasis.Color3,
				BackgroundTransparency = v.Color.Stroke.Emphasis.Transparency,
				BorderSizePixel = 0
			})
		end
	end

	return React.createElement("ScrollingFrame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		LayoutOrder = props.LayoutOrder,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ScrollBarThickness = 0,
		ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
		[React.Change.AbsoluteSize] = fn
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, padding)
		}),
		Cells = React.createElement(React.Fragment, {}, children)
	})
end
