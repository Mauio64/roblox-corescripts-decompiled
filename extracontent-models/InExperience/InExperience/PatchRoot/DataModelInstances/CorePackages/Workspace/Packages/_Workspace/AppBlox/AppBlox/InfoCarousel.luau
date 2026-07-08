local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local useDesignTokens = require(Parent.Style).useDesignTokens
local InfoCarouselCell = require(script.Parent.InfoCarouselCell)

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: useDesignTokens (copy), React (copy), InfoCarouselCell (copy)
	local v6 = useDesignTokens()
	local v7 = t1.padding or v6.Size.Size_600
	local v8, v9 = React.useBinding(0)
	local t2 = {}

	for v11, v12 in t1.data do
		t2["Cell" .. v11] = React.createElement(InfoCarouselCell, {
			LayoutOrder = v11 * 2,
			headerText = v12.headerText,
			bodyText = v12.bodyText,
			icon = v12.icon,
			iconSize = t1.iconSize,
			onActivated = v12.onActivated,
			padding = t1.cellPadding
		})

		if v11 < #t1.data then
			t2["Divider" .. v11] = React.createElement("Frame", {
				BorderSizePixel = 0,
				LayoutOrder = v11 * 2 + 1,
				Size = v8:map(function(n1: number) -- line: 42
					return UDim2.fromOffset(1, n1 / 2)
				end),
				BorderColor3 = v6.Color.Stroke.Emphasis.Color3,
				BackgroundTransparency = v6.Color.Stroke.Emphasis.Transparency
			})
		end
	end

	return React.createElement("ScrollingFrame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		LayoutOrder = t1.LayoutOrder,
		ScrollingDirection = Enum.ScrollingDirection.X,
		ScrollBarThickness = 0,
		ElasticBehavior = Enum.ElasticBehavior.WhenScrollable,
		[React.Change.AbsoluteSize] = function(p1) -- line: 24
			-- upvalues: v9 (copy)
			v9(p1.AbsoluteSize.Y)
		end
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v7)
		}),
		Cells = React.createElement(React.Fragment, {}, t2)
	})
end
