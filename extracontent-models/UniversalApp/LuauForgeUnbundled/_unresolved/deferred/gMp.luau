local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local withLocalization = require("@game/CorePackages/Workspace/Packages/Localization").withLocalization

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

return function(data)
	local v5 = useDesignTokens()

	return withLocalization({
		statusPrimaryText = data.statusPrimaryText,
		statusSecondaryText = data.statusSecondaryText
	})(function(p2)
		local createElement = React.createElement
		local v7 = {
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = Enum.AutomaticSize.XY,
			BackgroundTransparency = 1
		}
		local v9

		if data.submitError then
			v9 = React.createElement("TextLabel", {
				Position = UDim2.new(0, 0, 1, -v5.Typography.TitleLarge.FontSize - v5.Size.Size_300),
				Text = p2.statusPrimaryText,
				FontFace = normalizeFontFace(v5.Typography.BodyLarge.Font),
				TextColor3 = data.color,
				TextSize = v5.Typography.BodyLarge.FontSize,
				Size = UDim2.new(1, 0, 0, v5.Typography.TitleLarge.FontSize),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left
			})
		elseif data.BEDUIError then
			v9 = React.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0.9, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					BackgroundTransparency = 1
				},
				{
					Layout = React.createElement("UIListLayout", {
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						VerticalAlignment = Enum.VerticalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					PrimaryText = React.createElement("TextLabel", {
						AutomaticSize = Enum.AutomaticSize.XY,
						Text = data.statusPrimaryText,
						FontFace = normalizeFontFace(v5.Typography.HeadingLarge.Font),
						LayoutOrder = 1,
						TextColor3 = v5.Color.Content.Emphasis.Color3,
						TextTransparency = v5.Color.Content.Emphasis.Transparency,
						TextSize = v5.Typography.HeadingLarge.FontSize,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Center,
						Size = UDim2.new(1, 0, 0, v5.Typography.HeadingLarge.FontSize),
						BackgroundTransparency = 1
					}, {
						Padding = React.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, v5.Size.Size_400)
						})
					}),
					SecondaryText = React.createElement("TextLabel", {
						AutomaticSize = Enum.AutomaticSize.XY,
						Text = data.statusSecondaryText,
						FontFace = normalizeFontFace(v5.Typography.HeadingSmall.Font),
						LayoutOrder = 2,
						TextColor3 = v5.Color.Content.Default.Color3,
						TextTransparency = v5.Color.Content.Emphasis.Transparency,
						TextSize = v5.Typography.HeadingSmall.FontSize,
						TextWrapped = true,
						TextXAlignment = Enum.TextXAlignment.Center,
						Size = UDim2.new(1, 0, 0, v5.Typography.HeadingSmall.FontSize),
						BackgroundTransparency = 1
					})
				}
			)
		end

		return createElement("Frame", v7, { FetchStatus = v9 })
	end)
end
