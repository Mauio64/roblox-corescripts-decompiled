local ParentParent = script.Parent.Parent
local ParentParent2 = ParentParent.Parent.Parent.Parent
local Cryo = require(ParentParent2.Cryo)

require(script.Parent.Types)
require(ParentParent.StyleTypes)

local function getOnHoverColor(p1, p2) -- line: 29
	local Hover = p2.Color.State.Hover

	if Hover.Transparency == 1 then
		return {
			Color3 = p1.Color3,
			Transparency = p1.Transparency
		}
	end

	if p1.Color3 == nil or p1.Transparency == 1 then
		return {
			Color3 = Hover.Color3,
			Transparency = Hover.Transparency
		}
	end

	return {
		Color3 = p1.Color3:Lerp(Hover.Color3, 1 - Hover.Transparency),
		Transparency = p1.Transparency
	}
end

local t1 = {
	"Color",
	"Config",
	"DarkMode",
	"Ease",
	"LightMode",
	"Inverse",
	"Size",
	"Padding",
	"Margin",
	"Gap",
	"Gutter",
	"Radius",
	"Stroke",
	"LineHeight",
	"FontSize",
	"FontWeight",
	"Time",
	"Typography"
}

return {
	mapColorTokensToFoundation = function(p3, p4) -- line: 18
		-- upvalues: Cryo (copy)
		p3.Semantic.Color = Cryo.Dictionary.join(p3.Semantic.Color, p4.Semantic.Color)
		p3.Global.Color = Cryo.Dictionary.join(p3.Global.Color, p4.Global.Color)
		p3.Component = Cryo.Dictionary.join(p3.Component, p4.Component)

		return p3
	end,
	mapThemeToFoundation = function(p5, p6) -- line: 50
		-- upvalues: getOnHoverColor (copy), Cryo (copy)
		local t2 = {
			BackgroundDefault = p6.Color.Surface.Surface_0,
			BackgroundContrast = p6.Color.Surface.Surface_100,
			BackgroundMuted = p6.Color.Surface.Surface_200,
			BackgroundUIDefault = p6.Color.Surface.Surface_300,
			BackgroundUIContrast = p6.Color.OverMedia.OverMedia_0,
			BackgroundOnHover = p6.Color.State.Hover,
			BackgroundOnPress = p6.Color.State.Press,
			UIDefault = p6.Color.Shift.Shift_200,
			UIMuted = p6.Color.Shift.Shift_100,
			UIEmphasis = p6.Color.Shift.Shift_400,
			ContextualPrimaryDefault = p6.Color.ActionEmphasis.Background,
			ContextualPrimaryOnHover = getOnHoverColor(p6.Color.ActionEmphasis.Background, p6),
			ContextualPrimaryContent = p6.Color.ActionEmphasis.Foreground,
			SystemPrimaryDefault = p6.Color.ActionSubEmphasis.Background,
			SystemPrimaryOnHover = getOnHoverColor(p6.Color.ActionSubEmphasis.Background, p6),
			SystemPrimaryContent = p6.Color.ActionSubEmphasis.Foreground,
			IconDefault = p6.Color.Content.Default,
			IconEmphasis = p6.Color.Content.Emphasis,
			IconOnHover = p6.Color.Content.Emphasis,
			TextEmphasis = p6.Color.Content.Emphasis,
			TextDefault = p6.Color.Content.Default,
			TextMuted = p6.Color.Content.Muted,
			TextLink = p6.Color.Content.Link,
			Divider = p6.Color.Stroke.Emphasis,
			Overlay = p6.Color.Common.Scrim,
			DropShadow = p6.Color.Common.Shadow,
			NavigationBar = p6.Color.Common.NavigationBar,
			PlaceHolder = p6.Color.Common.Shimmer,
			OnlineStatus = p6.Color.System.Success,
			OfflineStatus = p6.Color.System.Neutral,
			Success = p6.Color.System.Success,
			Alert = p6.Color.System.Alert,
			Badge = p6.Color.System.Contrast,
			BadgeContent = p6.Inverse.Content.Emphasis
		}

		return (Cryo.Dictionary.join(p5, Cryo.Dictionary.map(t2, function(p7) -- line: 90
			return {
				Color = p7.Color3,
				Transparency = p7.Transparency
			}
		end)))
	end,
	addFoundationFlatKeys = function(p8, p9) -- line: 123
		-- upvalues: t1 (copy)
		for _, v17 in t1 do
			p8[v17] = p9[v17]
		end

		return p8
	end
}
