local parent = script.Parent.Parent
local Colors = require(parent.Colors)

return {
	BackgroundDefault = { Color = Colors.Slate, Transparency = 0 },
	BackgroundContrast = { Color = Colors.Carbon, Transparency = 0 },
	BackgroundMuted = { Color = Colors.Obsidian, Transparency = 0 },
	BackgroundUIDefault = { Color = Colors.Flint, Transparency = 0 },
	BackgroundUIContrast = { Color = Colors.Black, Transparency = 0.3 },
	BackgroundOnHover = { Color = Colors.White, Transparency = 0.9 },
	BackgroundOnPress = { Color = Colors.Black, Transparency = 0.7 },
	UIDefault = { Color = Colors.Graphite, Transparency = 0 },
	UIMuted = { Color = Colors.Obsidian, Transparency = 0.2 },
	UIEmphasis = { Color = Colors.White, Transparency = 0.7 },
	ContextualPrimaryDefault = { Color = Colors.Green, Transparency = 0 },
	ContextualPrimaryOnHover = { Color = Colors.Green, Transparency = 0 },
	ContextualPrimaryContent = { Color = Colors.White, Transparency = 0 },
	SystemPrimaryDefault = { Color = Colors.White, Transparency = 0 },
	SystemPrimaryOnHover = { Color = Colors.White, Transparency = 0 },
	SystemPrimaryContent = { Color = Colors.Flint, Transparency = 0 },
	SecondaryDefault = { Color = Colors.White, Transparency = 0.3 },
	SecondaryOnHover = { Color = Colors.White, Transparency = 0 },
	SecondaryContent = { Color = Colors.White, Transparency = 0.3 },
	IconDefault = { Color = Colors.White, Transparency = 0.3 },
	IconEmphasis = { Color = Colors.White, Transparency = 0 },
	IconOnHover = { Color = Colors.White, Transparency = 0 },
	TextEmphasis = { Color = Colors.White, Transparency = 0 },
	TextDefault = { Color = Colors.Pumice, Transparency = 0 },
	TextMuted = { Color = Colors.White, Transparency = 0.3 },
	TextLink = { Color = Colors.Blue, Transparency = 0 },
	Divider = { Color = Colors.White, Transparency = 0.8 },
	Overlay = { Color = Colors.Black, Transparency = 0.5 },
	DropShadow = { Color = Colors.Black, Transparency = 0.5 },
	NavigationBar = { Color = Colors.Carbon, Transparency = 0 },
	PlaceHolder = { Color = Colors.Flint, Transparency = 0.5 },
	OnlineStatus = { Color = Colors.Green, Transparency = 0 },
	OfflineStatus = { Color = Colors.White, Transparency = 0.3 },
	Success = { Color = Colors.Green, Transparency = 0 },
	Alert = { Color = Colors.Red, Transparency = 0 },
	Badge = { Color = Colors.White, Transparency = 0 },
	BadgeContent = { Color = Colors.Flint, Transparency = 0 },
	SelectionCursor = {
		Color = Colors.White,
		Transparency = 0,
		AnimatedColor = Colors.White,
		GradientRotationSpeed = 2,
		GradientColorSequence = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(1, Color3.new(0.336, 0.336, 0.336))
		}),
		GradientTransparencySequence = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 0)
		})
	},
	PlayerBackgroundDefault = {
		Color = Colors.White,
		Transparency = 0,
		Image = "component_assets/avatarBG_dark"
	},
	ItemBackgroundDefault = {
		Color = Colors.Black,
		Transparency = 0,
		Image = "component_assets/itemBG_dark"
	}
}
