local ParentParent = script.Parent.Parent.Parent.Parent.Parent

require(script.Parent.TokenDefaults)

local v2 = require(ParentParent.RbxDesignFoundationsV2).Tokens.Dark(1)
local _ = {
	Color = v2.Color,
	Config = v2.Config,
	DarkMode = v2.DarkMode,
	Ease = v2.Ease,
	LightMode = v2.LightMode,
	Inverse = v2.Inverse,
	Semantic = v2.Semantic,
	Size = v2.Size,
	Padding = v2.Padding,
	Margin = v2.Margin,
	Gap = v2.Gap,
	Gutter = v2.Gutter,
	Radius = v2.Radius,
	Stroke = v2.Stroke,
	LineHeight = v2.LineHeight,
	FontSize = v2.FontSize,
	FontWeight = v2.FontWeight,
	Time = v2.Time,
	Typography = v2.Typography
}

return {}
