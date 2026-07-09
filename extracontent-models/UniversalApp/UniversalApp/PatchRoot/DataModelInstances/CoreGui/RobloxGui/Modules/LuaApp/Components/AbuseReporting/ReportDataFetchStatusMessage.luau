local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Style = require(CorePackages.Workspace.Packages.Style)
local withLocalization = require(CorePackages.Workspace.Packages.Localization).withLocalization
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local mapTypographyVariantToFontEnum = Style.mapTypographyVariantToFontEnum

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: useDesignTokens (copy), withLocalization (copy), React (copy), mapTypographyVariantToFontEnum (copy)
	local v8 = useDesignTokens()

	return withLocalization({
		statusPrimaryText = t1.statusPrimaryText,
		statusSecondaryText = t1.statusSecondaryText
	})(function(p1) -- line: 24
		-- upvalues: React (copy), t1 (copy), v8 (copy), mapTypographyVariantToFontEnum (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			FetchStatus = if not t1.submitError then if not t1.BEDUIError then nil else React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0.9, 0),
				AutomaticSize = Enum.AutomaticSize.XY
			}, {
				Layout = React.createElement("UIListLayout", {
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				PrimaryText = React.createElement("TextLabel", {
					LayoutOrder = 1,
					TextWrapped = true,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = t1.statusPrimaryText,
					Font = mapTypographyVariantToFontEnum(v8.Typography.HeadingLarge),
					TextColor3 = v8.Color.Content.Emphasis.Color3,
					TextTransparency = v8.Color.Content.Emphasis.Transparency,
					TextSize = v8.Typography.HeadingLarge.FontSize,
					TextXAlignment = Enum.TextXAlignment.Center,
					Size = UDim2.new(1, 0, 0, v8.Typography.HeadingLarge.FontSize)
				}, {
					Padding = React.createElement("UIPadding", {
						PaddingBottom = UDim.new(0, v8.Size.Size_400)
					})
				}),
				SecondaryText = React.createElement("TextLabel", {
					LayoutOrder = 2,
					TextWrapped = true,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					Text = t1.statusSecondaryText,
					Font = mapTypographyVariantToFontEnum(v8.Typography.HeadingSmall),
					TextColor3 = v8.Color.Content.Default.Color3,
					TextTransparency = v8.Color.Content.Emphasis.Transparency,
					TextSize = v8.Typography.HeadingSmall.FontSize,
					TextXAlignment = Enum.TextXAlignment.Center,
					Size = UDim2.new(1, 0, 0, v8.Typography.HeadingSmall.FontSize)
				})
			}) else React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 0, 1, -v8.Typography.TitleLarge.FontSize - v8.Size.Size_300),
				Text = p1.statusPrimaryText,
				Font = mapTypographyVariantToFontEnum(v8.Typography.BodyLarge),
				TextColor3 = t1.color,
				TextSize = v8.Typography.BodyLarge.FontSize,
				Size = UDim2.new(1, 0, 0, v8.Typography.TitleLarge.FontSize),
				TextXAlignment = Enum.TextXAlignment.Left
			})
		})
	end)
end
