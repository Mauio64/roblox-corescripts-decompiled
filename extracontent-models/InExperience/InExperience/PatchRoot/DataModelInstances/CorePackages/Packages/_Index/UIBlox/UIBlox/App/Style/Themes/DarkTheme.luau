local ParentParent = script.Parent.Parent
local Colors = require(ParentParent.Colors)

return {
	BackgroundDefault = {
		Transparency = 0,
		Color = Colors.Slate
	},
	BackgroundContrast = {
		Transparency = 0,
		Color = Colors.Carbon
	},
	BackgroundMuted = {
		Transparency = 0,
		Color = Colors.Obsidian
	},
	BackgroundUIDefault = {
		Transparency = 0,
		Color = Colors.Flint
	},
	BackgroundUIContrast = {
		Transparency = 0.3,
		Color = Colors.Black
	},
	BackgroundOnHover = {
		Transparency = 0.9,
		Color = Colors.White
	},
	BackgroundOnPress = {
		Transparency = 0.7,
		Color = Colors.Black
	},
	UIDefault = {
		Transparency = 0,
		Color = Colors.Graphite
	},
	UIMuted = {
		Transparency = 0.2,
		Color = Colors.Obsidian
	},
	UIEmphasis = {
		Transparency = 0.7,
		Color = Colors.White
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
		Color = Colors.White
	},
	SystemPrimaryOnHover = {
		Transparency = 0,
		Color = Colors.White
	},
	SystemPrimaryContent = {
		Transparency = 0,
		Color = Colors.Flint
	},
	SecondaryDefault = {
		Transparency = 0.3,
		Color = Colors.White
	},
	SecondaryOnHover = {
		Transparency = 0,
		Color = Colors.White
	},
	SecondaryContent = {
		Transparency = 0.3,
		Color = Colors.White
	},
	IconDefault = {
		Transparency = 0.3,
		Color = Colors.White
	},
	IconEmphasis = {
		Transparency = 0,
		Color = Colors.White
	},
	IconOnHover = {
		Transparency = 0,
		Color = Colors.White
	},
	TextEmphasis = {
		Transparency = 0,
		Color = Colors.White
	},
	TextDefault = {
		Transparency = 0,
		Color = Colors.Pumice
	},
	TextMuted = {
		Transparency = 0.3,
		Color = Colors.White
	},
	TextLink = {
		Transparency = 0,
		Color = Colors.Blue
	},
	Divider = {
		Transparency = 0.8,
		Color = Colors.White
	},
	Overlay = {
		Transparency = 0.5,
		Color = Colors.Black
	},
	DropShadow = {
		Transparency = 0.5,
		Color = Colors.Black
	},
	NavigationBar = {
		Transparency = 0,
		Color = Colors.Carbon
	},
	PlaceHolder = {
		Transparency = 0.5,
		Color = Colors.Flint
	},
	OnlineStatus = {
		Transparency = 0,
		Color = Colors.Green
	},
	OfflineStatus = {
		Transparency = 0.3,
		Color = Colors.White
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
		Color = Colors.White
	},
	BadgeContent = {
		Transparency = 0,
		Color = Colors.Flint
	},
	SelectionCursor = {
		Transparency = 0,
		GradientRotationSpeed = 2,
		Color = Colors.White,
		AnimatedColor = Colors.White,
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
		Transparency = 0,
		Image = "component_assets/avatarBG_dark",
		Color = Colors.White
	},
	ItemBackgroundDefault = {
		Transparency = 0,
		Image = "component_assets/itemBG_dark",
		Color = Colors.Black
	}
}
