local Parent = script:FindFirstAncestor("AppBlox").Parent
local React = require(Parent.React)
local ImageSetLabel = require(Parent.UIBlox).Core.ImageSet.ImageSetLabel
local useDesignTokens = require(Parent.Style).useDesignTokens

return function(t1: {[any]: any}) -- line: 23
	-- upvalues: useDesignTokens (copy), React (copy), ImageSetLabel (copy)
	local v6 = useDesignTokens()
	local v7 = t1.padding or v6.Size.Size_100
	local v8 = t1.iconSize or 18
	local BodyLargeFont = v6.Typography.BodyLarge.Font
	local FontSize_350 = v6.FontSize.FontSize_350
	local Default = v6.Color.Content.Default
	local TitleLargeFont = v6.Typography.TitleLarge.Font
	local FontSize = v6.Typography.TitleLarge.FontSize
	local Emphasis = v6.Color.Content.Emphasis
	local v15 = React.createElement("TextLabel", {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Text = t1.bodyText,
		Font = TitleLargeFont,
		TextSize = FontSize,
		TextColor3 = Emphasis.Color3,
		TextTransparency = Emphasis.Transparency,
		TextYAlignment = Enum.TextYAlignment.Center
	})

	return React.createElement("TextButton", {
		AutomaticSize = Enum.AutomaticSize.XY,
		TextTransparency = 1,
		Text = "",
		BackgroundTransparency = 1,
		LayoutOrder = t1.LayoutOrder,
		[React.Event.Activated] = t1.onActivated
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, v7)
		}),
		Header = React.createElement("TextLabel", {
			LayoutOrder = 1,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY,
			Text = t1.headerText,
			Font = BodyLargeFont,
			TextSize = FontSize_350,
			TextColor3 = Default.Color3,
			TextTransparency = Default.Transparency,
			TextYAlignment = Enum.TextYAlignment.Center
		}),
		Body = if not t1.icon then v15 else React.createElement("Frame", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			BodyLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				Padding = UDim.new(0, v6.Size.Size_100)
			}),
			Icon = React.createElement(ImageSetLabel, {
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(v8, v8),
				Image = t1.icon,
				ImageColor3 = Emphasis.Color3,
				ImageTransparency = Emphasis.Transparency
			}),
			BodyText = v15
		})
	})
end
