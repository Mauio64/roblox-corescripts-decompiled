local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local Style = require("@game/CorePackages/Workspace/Packages/Style")
local module2 = require("@luauforge/deferred/gMo")

local useDesignTokens = Style.useDesignTokens

return function(props)
	local v5 = useDesignTokens()
	return React.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, v5.Size.Size_2800),
			BackgroundTransparency = 1,
			LayoutOrder = 2
		},
		{
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v5.Size.Size_600),
				PaddingBottom = UDim.new(0, v5.Size.Size_1400)
			}),
			TargetInner = React.createElement("Frame", {
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}, {
				Layout = React.createElement("UIListLayout", {
					FillDirection = Enum.FillDirection.Horizontal,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Thumbnail = React.createElement(module2, {
					thumbnailUrl = props.thumbnailUrl
				}),
				Texts = React.createElement(
					"Frame",
					{
						Size = UDim2.new(0, 0, 1, 0),
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundTransparency = 1
					},
					{
						Layout = React.createElement("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Left,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							SortOrder = Enum.SortOrder.LayoutOrder
						}),
						Padding = React.createElement("UIPadding", {
							PaddingLeft = UDim.new(0, v5.Size.Size_300)
						}),
						PrimaryText = React.createElement("TextLabel", {
							AutomaticSize = Enum.AutomaticSize.XY,
							Text = props.primaryText,
							FontFace = normalizeFontFace(v5.Typography.TitleLarge.Font),
							LayoutOrder = 1,
							TextColor3 = v5.Color.Content.Emphasis.Color3,
							TextTransparency = v5.Color.Content.Emphasis.Transparency,
							TextSize = v5.Typography.TitleLarge.FontSize,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
							Size = UDim2.new(0, 0, 0, v5.Typography.TitleLarge.FontSize),
							BackgroundTransparency = 1
						}),
						SecondaryText = React.createElement("TextLabel", {
							AutomaticSize = Enum.AutomaticSize.XY,
							Text = props.secondaryText,
							FontFace = normalizeFontFace(v5.Typography.BodyLarge.Font),
							LayoutOrder = 2,
							TextColor3 = v5.Color.Content.Default.Color3,
							TextTransparency = v5.Color.Content.Emphasis.Transparency,
							TextSize = v5.Typography.BodyLarge.FontSize,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
							Size = UDim2.new(0, 0, 0, v5.Typography.TitleLarge.FontSize),
							BackgroundTransparency = 1
						})
					}
				)
			})
		}
	)
end
