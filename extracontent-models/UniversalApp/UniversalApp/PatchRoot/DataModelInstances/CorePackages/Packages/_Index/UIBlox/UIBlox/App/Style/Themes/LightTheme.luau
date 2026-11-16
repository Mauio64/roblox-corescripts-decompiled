local parent = script.Parent.Parent
local Colors = require(parent.Colors)

return {
	BackgroundDefault = { Color = Colors.Alabaster, Transparency = 0 },
	BackgroundContrast = { Color = Colors.Ash, Transparency = 0 },
	BackgroundMuted = { Color = Colors.Chalk, Transparency = 0 },
	BackgroundUIDefault = { Color = Colors.White, Transparency = 0 },
	BackgroundUIContrast = { Color = Colors.White, Transparency = 0.1 },
	BackgroundOnHover = { Color = Colors.Black, Transparency = 0.9 },
	BackgroundOnPress = { Color = Colors.Black, Transparency = 0.9 },
	UIDefault = { Color = Colors.Pumice, Transparency = 0 },
	UIMuted = { Color = Colors.Black, Transparency = 0.9 },
	UIEmphasis = { Color = Colors.Black, Transparency = 0.7 },
	ContextualPrimaryDefault = { Color = Colors.Green, Transparency = 0 },
	ContextualPrimaryOnHover = { Color = Colors.Green, Transparency = 0 },
	ContextualPrimaryContent = { Color = Colors.White, Transparency = 0 },
	SystemPrimaryDefault = { Color = Colors.Flint, Transparency = 0 },
	SystemPrimaryOnHover = { Color = Colors.Flint, Transparency = 0 },
	SystemPrimaryContent = { Color = Colors.White, Transparency = 0 },
	SecondaryDefault = { Color = Colors.Black, Transparency = 0.5 },
	SecondaryOnHover = { Color = Colors.Flint, Transparency = 0 },
	SecondaryContent = { Color = Colors.Black, Transparency = 0.5 },
	IconDefault = { Color = Colors.Black, Transparency = 0.4 },
	IconEmphasis = { Color = Colors.Flint, Transparency = 0 },
	IconOnHover = { Color = Colors.Flint, Transparency = 0 },
	TextEmphasis = { Color = Colors.Flint, Transparency = 0 },
	TextDefault = { Color = Colors.Smoke, Transparency = 0 },
	TextMuted = { Color = Colors.Black, Transparency = 0.4 },
	TextLink = { Color = Colors.Blue, Transparency = 0 },
	Divider = { Color = Colors.Pumice, Transparency = 0 },
	Overlay = { Color = Colors.Black, Transparency = 0.7 },
	DropShadow = { Color = Colors.Black, Transparency = 0.7 },
	NavigationBar = { Color = Colors.White, Transparency = 0 },
	PlaceHolder = { Color = Colors.Black, Transparency = 0.9 },
	OnlineStatus = { Color = Colors.Green, Transparency = 0 },
	OfflineStatus = { Color = Colors.Black, Transparency = 0.5 },
	Success = { Color = Colors.Green, Transparency = 0 },
	Alert = { Color = Colors.Red, Transparency = 0 },
	Badge = { Color = Colors.Flint, Transparency = 0 },
	BadgeContent = { Color = Colors.White, Transparency = 0 },
	SelectionCursor = {
		Color = Colors.XboxBlue,
		Transparency = 0,
		AnimatedColor = Colors.White,
		GradientRotationSpeed = 2,
		GradientColorSequence = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.new(0.514, 0.82, 0.992)),
			ColorSequenceKeypoint.new(1, Color3.new(0.086, 0.678, 0.847))
		}),
		GradientTransparencySequence = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0),
			NumberSequenceKeypoint.new(1, 0)
		})
	},
	PlayerBackgroundDefault = {
		Color = Colors.White,
		Transparency = 0,
		Image = "component_assets/avatarBG_light"
	},
	ItemBackgroundDefault = {
		Color = Colors.White,
		Transparency = 0,
		Image = "component_assets/itemBG_light"
	}
}
