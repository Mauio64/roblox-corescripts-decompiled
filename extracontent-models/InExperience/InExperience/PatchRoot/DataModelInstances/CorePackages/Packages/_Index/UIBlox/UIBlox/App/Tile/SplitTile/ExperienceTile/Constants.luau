local parent = script.Parent.Parent.Parent.Parent

require(parent.Style.StyleTypes)
require(parent.Style.Fonts)

return {
	getDefaultStyleProps = function(p)
		assert(p.Tokens ~= nil, "Design token support is not enabled!")
		return {
			backgroundColor = {
				Color = p.Tokens.Color.Surface.Surface_200.Color3,
				Transparency = p.Tokens.Color.Surface.Surface_200.Transparency
			},
			border = {
				BorderColor = {
					Color = p.Tokens.Color.Stroke.Emphasis.Color3,
					Transparency = p.Tokens.Color.Stroke.Emphasis.Transparency
				},
				CornerRadius = UDim.new(0, p.Tokens.Radius.Medium),
				Width = p.Tokens.Stroke.Standard
			},
			topContentPadding = {
				Left = p.Tokens.Padding.None,
				Right = p.Tokens.Padding.None,
				Top = p.Tokens.Padding.None,
				Bottom = p.Tokens.Padding.None
			},
			bottomContentPadding = {
				Left = p.Tokens.Padding.Small,
				Right = p.Tokens.Padding.Small,
				Top = p.Tokens.Padding.Small,
				Bottom = p.Tokens.Padding.Small
			},
			overlayColors = {},
			selectionCursorPadding = { Left = 0, Right = 0, Top = 0, Bottom = 0 },
			dropShadow = {
				Position = UDim2.new(0.5, 0, 0.5, 2),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Size = UDim2.new(1, 10, 1, 12),
				ImageColor = {
					Color = p.Tokens.Color.Common.Shadow.Color3,
					Transparency = p.Tokens.Color.Common.Shadow.Transparency
				},
				ImageAssetName = "component_assets/dropshadow_24_6",
				SliceCenter = Rect.new(18, 18, 18, 18)
			},
			contentTitlePadding = p.Tokens.Size.Size_200,
			contentTitleFont = p.Font.Header2
		}
	end,
	DEFAULT_FOOTER_HEIGHT = 22,
	DEFAULT_TEXT_LINE_COUNT = 2
}
