local parent = script.Parent.Parent
local parent2 = parent.Parent.Parent.Parent

local Cryo = require(parent2.Cryo)

require(script.Parent.Types)
require(parent.StyleTypes)

local function getOnHoverColor(background, p)
	local hover = p.Color.State.Hover

	if hover.Transparency == 1 then
		return { Color3 = background.Color3, Transparency = background.Transparency }
	end

	if background.Color3 == nil or background.Transparency == 1 then
		return { Color3 = hover.Color3, Transparency = hover.Transparency }
	end

	return {
		Color3 = background.Color3:Lerp(hover.Color3, 1 - hover.Transparency),
		Transparency = background.Transparency
	}
end

local v = {
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
local Mappers = {}

function Mappers.mapColorTokensToFoundation(state, data)
	state.Semantic.Color = Cryo.Dictionary.join(state.Semantic.Color, data.Semantic.Color)
	state.Global.Color = Cryo.Dictionary.join(state.Global.Color, data.Global.Color)
	state.Component = Cryo.Dictionary.join(state.Component, data.Component)

	return state
end

function Mappers.mapThemeToFoundation(p, p2)
	local v2 = {
		BackgroundDefault = p2.Color.Surface.Surface_0,
		BackgroundContrast = p2.Color.Surface.Surface_100,
		BackgroundMuted = p2.Color.Surface.Surface_200,
		BackgroundUIDefault = p2.Color.Surface.Surface_300,
		BackgroundUIContrast = p2.Color.OverMedia.OverMedia_0,
		BackgroundOnHover = p2.Color.State.Hover,
		BackgroundOnPress = p2.Color.State.Press,
		UIDefault = p2.Color.Shift.Shift_200,
		UIMuted = p2.Color.Shift.Shift_100,
		UIEmphasis = p2.Color.Shift.Shift_400,
		ContextualPrimaryDefault = p2.Color.ActionEmphasis.Background,
		ContextualPrimaryOnHover = getOnHoverColor(p2.Color.ActionEmphasis.Background, p2),
		ContextualPrimaryContent = p2.Color.ActionEmphasis.Foreground,
		SystemPrimaryDefault = p2.Color.ActionSubEmphasis.Background,
		SystemPrimaryOnHover = getOnHoverColor(p2.Color.ActionSubEmphasis.Background, p2),
		SystemPrimaryContent = p2.Color.ActionSubEmphasis.Foreground,
		IconDefault = p2.Color.Content.Default,
		IconEmphasis = p2.Color.Content.Emphasis,
		IconOnHover = p2.Color.Content.Emphasis,
		TextEmphasis = p2.Color.Content.Emphasis,
		TextDefault = p2.Color.Content.Default,
		TextMuted = p2.Color.Content.Muted,
		TextLink = p2.Color.Content.Link,
		Divider = p2.Color.Stroke.Emphasis,
		Overlay = p2.Color.Common.Scrim,
		DropShadow = p2.Color.Common.Shadow,
		NavigationBar = p2.Color.Common.NavigationBar,
		PlaceHolder = p2.Color.Common.Shimmer,
		OnlineStatus = p2.Color.System.Success,
		OfflineStatus = p2.Color.System.Neutral,
		Success = p2.Color.System.Success,
		Alert = p2.Color.System.Alert,
		Badge = p2.Color.System.Contrast,
		BadgeContent = p2.Inverse.Content.Emphasis
	}

	return (Cryo.Dictionary.join(p, Cryo.Dictionary.map(v2, function(p3)
		return { Color = p3.Color3, Transparency = p3.Transparency }
	end)))
end

function Mappers.addFoundationFlatKeys(p, p2)
	for _, v2 in v do
		p[v2] = p2[v2]
	end

	return p
end

return Mappers
