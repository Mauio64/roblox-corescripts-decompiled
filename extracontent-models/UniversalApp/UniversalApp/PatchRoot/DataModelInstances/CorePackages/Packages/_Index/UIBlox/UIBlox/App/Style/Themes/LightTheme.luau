local ParentParent = script.Parent.Parent
local Colors = require(ParentParent.Colors)

return {
	BackgroundDefault = {
		Transparency = 0,
		Color = Colors.Alabaster
	},
	BackgroundContrast = {
		Transparency = 0,
		Color = Colors.Ash
	},
	BackgroundMuted = {
		Transparency = 0,
		Color = Colors.Chalk
	},
	BackgroundUIDefault = {
		Transparency = 0,
		Color = Colors.White
	},
	BackgroundUIContrast = {
		Transparency = 0.1,
		Color = Colors.White
	},
	BackgroundOnHover = {
		Transparency = 0.9,
		Color = Colors.Black
	},
	BackgroundOnPress = {
		Transparency = 0.9,
		Color = Colors.Black
	},
	UIDefault = {
		Transparency = 0,
		Color = Colors.Pumice
	},
	UIMuted = {
		Transparency = 0.9,
		Color = Colors.Black
	},
	UIEmphasis = {
		Transparency = 0.7,
		Color = Colors.Black
	},
	ContextualPrimaryDefault = {
		Transparency = 0,
		Color = Colors.Green
	},
	ContextualPrimaryOnHover = {
		Transparency = 0,
		Color = Colors.Green
	},
	ContextualPrimaryContent = {
		Transparency = 0,
		Color = Colors.White
	},
	SystemPrimaryDefault = {
		Transparency = 0,
		Color = Colors.Flint
	},
	SystemPrimaryOnHover = {
		Transparency = 0,
		Color = Colors.Flint
	},
	SystemPrimaryContent = {
		Transparency = 0,
		Color = Colors.White
	},
	SecondaryDefault = {
		Transparency = 0.5,
		Color = Colors.Black
	},
	SecondaryOnHover = {
		Transparency = 0,
		Color = Colors.Flint
	},
	SecondaryContent = {
		Transparency = 0.5,
		Color = Colors.Black
	},
	IconDefault = {
		Transparency = 0.4,
		Color = Colors.Black
	},
	IconEmphasis = {
		Transparency = 0,
		Color = Colors.Flint
	},
	IconOnHover = {
		Transparency = 0,
		Color = Colors.Flint
	},
	TextEmphasis = {
		Transparency = 0,
		Color = Colors.Flint
	},
	TextDefault = {
		Transparency = 0,
		Color = Colors.Smoke
	},
	TextMuted = {
		Transparency = 0.4,
		Color = Colors.Black
	},
	TextLink = {
		Transparency = 0,
		Color = Colors.Blue
	},
	Divider = {
		Transparency = 0,
		Color = Colors.Pumice
	},
	Overlay = {
		Transparency = 0.7,
		Color = Colors.Black
	},
	DropShadow = {
		Transparency = 0.7,
		Color = Colors.Black
	},
	NavigationBar = {
		Transparency = 0,
		Color = Colors.White
	},
	PlaceHolder = {
		Transparency = 0.9,
		Color = Colors.Black
	},
	OnlineStatus = {
		Transparency = 0,
		Color = Colors.Green
	},
	OfflineStatus = {
		Transparency = 0.5,
		Color = Colors.Black
	},
	Success = {
		Transparency = 0,
		Color = Colors.Green
	},
	Alert = {
		Transparency = 0,
		Color = Colors.Red
	},
	Badge = {
		Transparency = 0,
		Color = Colors.Flint
	},
	BadgeContent = {
		Transparency = 0,
		Color = Colors.White
	},
	SelectionCursor = {
		Transparency = 0,
		GradientRotationSpeed = 2,
		Color = Colors.XboxBlue,
		AnimatedColor = Colors.White,
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
		Transparency = 0,
		Image = "component_assets/avatarBG_light",
		Color = Colors.White
	},
	ItemBackgroundDefault = {
		Transparency = 0,
		Image = "component_assets/itemBG_light",
		Color = Colors.White
	}
}
